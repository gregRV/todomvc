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

	def edit
		@todo = Todo.find(params[:id])
		unless @todo && (current_user == @todo.user)
			flash[:notice] = "Access forbidden"
			redirect_to user_todo_path(@todo.user, @todo) and return
		end
	end

	def update
		@todo = Todo.find(params[:id])
		@todo.update(todos_params)
		redirect_to user_todo_path(@todo.user, @todo)
	end

	# def destroy
	# 	@todo = Todo.find(params[:id])
	# 	@todo.destroy
	# 	redirect_to root_path
	# end

	private

	def todos_params
		params.require(:todo).permit(:title, :body)
	end
end
