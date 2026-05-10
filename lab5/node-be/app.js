const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const UserRoute = require("./routers/user.routes");
const ToDoRoute = require('./routers/todo.routes');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use("/", UserRoute);
app.use("/", ToDoRoute);

module.exports = app;