const express = require("express");
const router = express.Router();
const taskController = require("../controllers/taskController");

// CRUD Routes
router.get("/", taskController.getAllTasks);
router.get("/:id", taskController.getTaskById);
router.post("/", taskController.createTask);
router.put("/:id", taskController.updateTask);
router.delete("/:id", taskController.deleteTask);

// Additional route for toggling completion
router.patch("/:id/toggle", taskController.toggleTaskCompletion);

module.exports = router;
