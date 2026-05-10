const mongoose = require('mongoose');
const UserModel = require("./user.model");
const { Schema } = mongoose;

const toDoSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName
    },
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
}, { timestamps: true });

const ToDoModel = mongoose.model('todo', toDoSchema);
module.exports = ToDoModel;