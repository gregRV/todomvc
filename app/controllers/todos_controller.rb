class TodosController < ApplicationController
	def new
		@user = User.find(params[:user_id])
		@todo = Todo.new
	end

	def create
		@todo = current_user.todos.new(todos_params)
		if @todo.save
			redirect_to user_todo_path(current_user, @todo) and return
		end
		redirect_to root_path
	end

	private

	def todos_params
		params.require(:todo).permit(:title, :body)
	end
end
