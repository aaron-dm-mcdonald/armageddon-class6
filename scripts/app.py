from flask import Flask, jsonify, request, render_template_string
import requests
import pymysql
import os

app = Flask(__name__)

############### Database Config ###############

# MySQL RDS configuration (replace with your RDS endpoint, username, and password)
DB_HOST = os.environ['DB_HOST']
DB_USER = os.environ['DB_USER']
DB_PASSWORD = os.environ['DB_PASSWORD']
DB_NAME = 'user_db'

# Connect to the database
def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )
############### Test Picture ###############

# Route to display the image with some HTML saying "test picture"
@app.route('/test-picture', methods=['GET'])
def test_picture():
    # HTML template with an embedded image
    html_content = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Test Picture</title>
    </head>
    <body>
        <h1>Test Picture</h1>
        <img src="https://scontent-sea1-1.cdninstagram.com/v/t51.29350-15/344456093_6144976788957239_4788714379343087335_n.jpg?stp=dst-jpg_e35_p1080x1080_tt6&_nc_ht=scontent-sea1-1.cdninstagram.com&_nc_cat=111&_nc_ohc=QVsbXyePD84Q7kNvgG1K7E-&_nc_gid=0833f4c72afb497ab339237e12132b05&edm=AGenrX8BAAAA&ccb=7-5&oh=00_AYAooi6YA5vTUu3nUjIN3qrSbTShS7WYyC0p815BpWtjLQ&oe=676D02CE&_nc_sid=ed990e" alt="Test Picture">
        <h1>Test Picture</h1>
        <img src="https://www.w3.org/MarkUp/Test/PNG/test.png" alt="Test Picture">
    </body>
    </html>
    '''
    return render_template_string(html_content)

############### Functions for EC2 Metadata ###############

# Function to get metadata
def get_metadata(path):
    url = f"http://169.254.169.254/latest/meta-data/{path}"
    response = requests.get(url, headers={"X-aws-ec2-metadata-token": get_metadata_token()})
    return response.text

# Get the IMDSv2 token
def get_metadata_token():
    url = "http://169.254.169.254/latest/api/token"
    headers = {"X-aws-ec2-metadata-token-ttl-seconds": "21600"}
    response = requests.put(url, headers=headers)
    return response.text


############### Endpoints for API ###############

# Route to fetch EC2 region
@app.route('/metadata/region', methods=['GET'])
def metadata_region():
    # Fetch the availability zone
    az = get_metadata("placement/availability-zone")
    # Region is the AZ name with the last character removed
    region = az[:-1]
    return jsonify({"region": region}), 200

# Route to fetch EC2 instance name
@app.route('/metadata/instance-name', methods=['GET'])
def metadata_instance_name():
    # Fetch the instance name from the EC2 instance metadata
    instance_name = get_metadata("tags/instance-name")
    return jsonify({"instance-name": instance_name}), 200


# DB Endpoints

# POST endpoint to add a user
@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    connection = get_db_connection()
    with connection.cursor() as cursor:
        sql = "INSERT INTO users (username, password) VALUES (%s, %s)"
        cursor.execute(sql, (username, password))
    connection.commit()
    connection.close()

    return jsonify({'message': 'User added successfully'}), 201

# GET endpoint to retrieve all users
@app.route('/get_users', methods=['GET'])
def get_users():
    connection = get_db_connection()
    with connection.cursor() as cursor:
        sql = "SELECT username, password FROM users"
        cursor.execute(sql)
        users = cursor.fetchall()
    connection.close()

    return jsonify({'users': users}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
