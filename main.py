from bson import ObjectId
from flask import *
from flask_pymongo import PyMongo
import json

app = Flask('QuizApp')
app.config[
    'MONGO_URI'] = 'mongodb+srv://dbuser:databasepassword@mycluster.rvhdw.mongodb.net/QuizAppDatabase?retryWrites=true&w=majority'

mongo = PyMongo(app)


@app.route('/register', methods=['POST'])
def register():
    if mongo.db.Users.find_one({'email': request.json['email']}):
        return {'message' : 'That email is already in use.'}
    else:
        mongo.db.Users.insert_one(request.json)
        return {'message': 'Success! You are being redirected to the login page.'}

@app.route('/login', methods=['POST'])
def login():
    if mongo.db.Users.find_one({'email':request.json['email'], 'password':request.json['password']}):
        user = mongo.db.Users.find_one({'email':request.json['email']})
        return {'message' : 'Success! You are being logged in.', 'success': True, 'quizScores':user['quizScores']}
    else:
        return {'message' : 'Incorrect email or password.', 'success': False}

@app.route('/getQuiz', methods=['POST'])
def getQuiz():
    if mongo.db.Quizes.find_one({'quizName': request.json['quizName']}):
        quiz = mongo.db.Quizes.find_one({'quizName': request.json['quizName']})
        return {'questions' : quiz['questions']}
    else:
        return {'message': 'Quiz not found.'}

@app.route('/saveScore', methods=['POST'])
def saveScore():
    user = mongo.db.Users.find_one({'email': request.json['userEmail']})
    user['quizScores'][request.json['quizName']] = request.json['score']
    print(user['quizScores'])
    print(request.json)
    mongo.db.Users.update_one({"email": request.json['userEmail']}, {"$set": {'quizScores': user['quizScores']}})
    return {'message': 'Score updated.'}

@app.route('/getQuizScores', methods=['POST'])
def getQuizScores():
    user = mongo.db.Users.find_one({'email': request.json['email']})
    return {'message':'Scores fetched', 'quizScores': user['quizScores']}

app.run(host='0.0.0.0',
        debug=True)
