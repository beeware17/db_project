from flask import Flask, jsonify, request
import sqlite3

app = Flask(__name__)

# Create an in-memory SQLite database
def init_db():
    conn = sqlite3.connect(':memory:')  # In-memory database
    c = conn.cursor()
    c.execute('''CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT)''')
    c.execute("INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com')")
    conn.commit()
    conn.close()

# Get all users from the in-memory database
@app.route('/users', methods=['GET'])
def get_users():
    conn = sqlite3.connect(':memory:')  # In-memory database
    c = conn.cursor()
    c.execute("SELECT * FROM users")
    users = c.fetchall()
    conn.close()

    return jsonify(users)

# Create a new user
@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    conn = sqlite3.connect(':memory:')
    c = conn.cursor()
    c.execute("INSERT INTO users (name, email) VALUES (?, ?)", (data['name'], data['email']))
    conn.commit()
    conn.close()
    return jsonify({"message": "User created successfully"}), 201

if __name__ == '__main__':
    init_db()  # Initialize the in-memory DB
    app.run(debug=True)
