from flask import Flask, jsonify, request
import psycopg2
import os

app = Flask(__name__)

# Connect to PostgreSQL
db_host = os.getenv('POSTGRES_HOST', 'localhost')
db_name = os.getenv('POSTGRES_DB', 'demo_db')
db_user = os.getenv('POSTGRES_USER', 'postgres')
db_password = os.getenv('POSTGRES_PASSWORD', 'password')


def get_db_connection():
    return psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_password
    )


# Get all users from PostgreSQL
@app.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT id, name, email FROM users;')
    users = cur.fetchall()
    cur.close()
    conn.close()

    result = [{'id': user[0], 'name': user[1], 'email': user[2]} for user in users]
    return jsonify(result)


# Create a new user
@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('INSERT INTO users (name, email) VALUES (%s, %s) RETURNING id;', (data['name'], data['email']))
    user_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"message": "User created successfully", "id": user_id}), 201


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
