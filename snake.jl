using Makie

res = 500
game = Scene(resolution=(res, res))
campixel!(game)
cell = 10
cells = res ÷ 10
snakelen = 5
middle = cells ÷ 2
snakestart = middle - (snakelen ÷ 2)
segments = Point2f0.(middle, range(snakestart, step=cell, length=snakelen))
snake = scatter!(game, segments, markersize=cell, raw=true, color=:blue)[end]
speed = 1 / 5
global last_dir = (0, 1)
dir = lift(game.events.keyboardbuttons) do but
    global last_dir
    ispressed(but, Keyboard.left) && return (last_dir = (-1, 0))
    ispressed(but, Keyboard.up) && return (last_dir = (0, 1))
    ispressed(but, Keyboard.right) && return (last_dir = (1, 0))
    ispressed(but, Keyboard.down) && return (last_dir = (0, -1))
    last_dir
end
display(game)
newsnake = copy(segments)
while isopen(game)
    curr_snake = snake[1][]
    circshift!(newsnake, curr_snake, 1)
    newsnake[1] = newsnake[2] .+ Point2f0(dir[] .* cell)
    snake[1] = newsnake
    newsnake = curr_snake
    sleep(speed)
end