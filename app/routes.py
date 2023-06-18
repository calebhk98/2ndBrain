from flask import render_template, url_for, redirect, flash, request
from flask_login import login_user, current_user, logout_user, login_required
from app import app, db, bcrypt
from app.models import User

@app.route("/register", methods=['GET', 'POST'])
def register():
    # Redirect logged-in users to the home page
    if current_user.is_authenticated:
        return redirect(url_for('home'))

    # Handle form submission for user registration
    if request.method == 'POST':
        # Get user data from the form
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        # Generate a hashed password using bcrypt
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        # Create a new User instance and add it to the database
        user = User(username=username, email=email, password=hashed_password)
        db.session.add(user)
        db.session.commit()

        # Show a success message and redirect the user to the login page
        flash('Your account has been created. You can now log in.', 'success')
        return redirect(url_for('login'))
    
    # Render the registration form
    return render_template('register.html')


@app.route("/login", methods=['GET', 'POST'])
def login():
    # (login logic as previously defined)
    # Redirect logged-in users to the home page
    if current_user.is_authenticated:
        return redirect(url_for('home'))

    # Handle form submission for user login
    if request.method == 'POST':
        # Get user data from the form
        email = request.form['email']
        password = request.form['password']

        # Check if a user with the provided email exists in the database
        user = User.query.filter_by(email=email).first()

        # Verify the provided password against the stored hashed password
        if user and bcrypt.check_password_hash(user.password, password):
            # Log in the user and redirect to the home page
            login_user(user)
            return redirect(url_for('home'))
        else:
            # Show an error message if the login attempt was unsuccessful
            flash('Login unsuccessful. Please check email and password.', 'danger')
    
    # Render the login form
    return render_template('login.html')


@app.route("/logout")
@login_required
def logout():
    # (logout logic as previously defined)
    # Log out the current user and redirect to the login page
    logout_user()
    return redirect(url_for('login'))


@app.route("/home")
@login_required
def home():
    return render_template('home.html')
