#!/bin/bash

# Check if Node.js is installed
if ! command -v node &> /dev/null
then
    echo "Node.js is not installed. Please install Node.js before running this script."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null
then
    echo "npm is not installed. Please install npm before running this script."
    exit 1
fi

# Create project directory and move into it
mkdir express-app
cd express-app

# Initialize npm and create package.json
npm init -y

# Install required dependencies
npm install express dotenv ejs body-parser morgan --save

# Create the project directory structure
mkdir -p src/{controllers,models,views,routes} public/{css,images,js} config

# Create .env file for environment variables
cat <<EOL > .env
PORT=3000
NODE_ENV=development
EOL

# Create a basic Express app in src/app.js
cat <<EOL > src/app.js
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const dotenv = require('dotenv');
const routes = require('./routes/index');

// Load environment variables
dotenv.config();

const app = express();

// Set view engine
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(morgan('dev'));

// Serve static files
app.use(express.static(path.join(__dirname, '../public')));

// Routes
app.use('/', routes);

// Error handling for 404 - Page Not Found
app.use((req, res, next) => {
    res.status(404).render('404', { title: '404 - Not Found' });
});

// Error handling for other errors
app.use((err, req, res, next) => {
    res.status(500).render('500', { title: '500 - Server Error' });
});

// Get port from environment variables and start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(\`Server running in \${process.env.NODE_ENV} mode on port http://localhost:\${PORT}\`);
});
EOL

# Create the main route in src/routes/index.js
cat <<EOL > src/routes/index.js
const express = require('express');
const router = express.Router();
const homeController = require('../controllers/homeController');

// Home route
router.get('/', homeController.getHome);

module.exports = router;
EOL

# Create a basic controller for the home page in src/controllers/homeController.js
cat <<EOL > src/controllers/homeController.js
exports.getHome = (req, res) => {
    res.render('home', { title: 'Home Page' });
};
EOL

# Create a simple model file (example) in src/models/exampleModel.js
cat <<EOL > src/models/exampleModel.js
// Example model
// This would typically connect to a database, such as MongoDB or PostgreSQL

exports.getData = () => {
    return { message: 'This is some example data from the model' };
};
EOL

# Create basic EJS views in src/views

# Home page view in src/views/home.ejs
cat <<EOL > src/views/home.ejs
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <h1>Welcome to the Home Page</h1>
    <p>This is the initial setup of your Express app using MVC structure.</p>
</body>
</html>
EOL

# 404 error page view in src/views/404.ejs
cat <<EOL > src/views/404.ejs
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
</head>
<body>
    <h1>404 - Page Not Found</h1>
    <p>Sorry, the page you are looking for does not exist.</p>
</body>
</html>
EOL

# 500 error page view in src/views/500.ejs
cat <<EOL > src/views/500.ejs
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
</head>
<body>
    <h1>500 - Server Error</h1>
    <p>Something went wrong on the server.</p>
</body>
</html>
EOL

# Create a basic CSS file in public/css/style.css
cat <<EOL > public/css/style.css
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    text-align: center;
}
h1 {
    color: #333;
}
EOL

# Create the server start script
cat <<EOL > server.js
require('./src/app');
EOL

cd $projectName
npm install 
nodemon server.js

# Output final instructions for the user
echo "Express project structure created successfully!"
echo "To run your project:"
echo "1. Run 'npm install' to install dependencies."
echo "2. Run 'node server.js' to start the server."
echo "3. Visit http://localhost:3000 to view the app."


