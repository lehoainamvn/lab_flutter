const ToDoService = require('../services/todo.service');

exports.createToDo = async (req, res, next) => {
    try {
        const { userId, title, description } = req.body;
        let todoData = await ToDoService.createToDo(userId, title, description);
        res.json({ status: true, success: todoData });
    } catch (error) {
        next(error);
    }
}

exports.getToDoList = async (req, res, next) => {
    try {
        const { userId } = req.body;
        let todoData = await ToDoService.getUserToDoList(userId);
        res.json({ status: true, success: todoData });
    } catch (error) {
        next(error);
    }
}

exports.deleteToDo = async (req, res, next) => {
    try {
        const { id } = req.body;
        let deletedData = await ToDoService.deleteToDo(id);
        res.json({ status: true, success: deletedData });
    } catch (error) {
        next(error);
    }
}