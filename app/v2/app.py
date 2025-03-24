from flask import Flask, jsonify, request
from pymongo import MongoClient
import os

app = Flask(__name__)

# Connect to MongoDB
mongo_address = os.getenv('MONGO_ADDR', 'mongodb://localhost:27017/')
client = MongoClient(mongo_address)
db = client['demo_db']
users_collection = db['users']

# Get all users from MongoDB
@app.route('/users', methods=['GET'])
def get_users():
    users = users_collection.find()
    result = []
    for user in users:
        user['_id'] = str(user['_id'])  # Convert ObjectId to string
        result.append(user)
    return jsonify(result)

# Create a new user
@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    user = {
        'name': data['name'],
        'email': data['email']
    }
    users_collection.insert_one(user)
    return jsonify({"message": "User created successfully"}), 201

if __name__ == '__main__':
    app.run(debug=True)
