const router = require("express").Router();
const ToDoController = require('../controller/todo.controller');

router.post("/storeTodo", ToDoController.createToDo);
router.post('/getUserTodoList', ToDoController.getToDoList); // Dùng POST để nhận userId trong body
router.post("/deleteTodo", ToDoController.deleteToDo);

module.exports = router;