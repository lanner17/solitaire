@enum PINS begin
   EMPTY
   PIN
   INVALID
end

start_pos = [
   INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
   INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
   PIN,    PIN,    PIN,PIN,  PIN,PIN,    PIN,
   PIN,    PIN,    PIN,EMPTY,PIN,PIN,    PIN,
   PIN,    PIN,    PIN,PIN,  PIN,PIN,    PIN,
   INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
   INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
]

# inversion of starting position
solution_pos = map(x -> if x == PIN EMPTY elseif x == EMPTY PIN else INVALID end, start_pos)

mutable struct position_t
    moves::Vector{Tuple{Int64,Int64}}
    pos::Vector{PINS}
end

//u d l r

function valid_left(pos::Vector{PINS}, pin::Int64)
    endv = pin - 2;
    midv = pin - 1;
    return  ((endv > 1) && (((pin - 1) ÷ 7) == ((endv - 1) ÷ 7)) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY))
end

function valid_right(pos::Vector{PINS}, pin::Int64)
    endv = pin + 2;
    midv = pin + 1;
    return  ((endv < 50) && (((pin - 1) ÷ 7) == ((endv - 1) ÷ 7)) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY))
end

function valid_up(pos::Vector{PINS}, pin::Int64)
    endv = pin - 14
    midv = pin - 7
    return  ((endv >= 1) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY))
end

function valid_dn(pos::Vector{PINS}, pin::Int64)
    endv = pin + 14;
    midv = pin + 7;
    return  ((endv < 50) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY))
end

//fast d u l r
//slow l r d u
function get_moves(pos::Vector{PINS})
    moves = []

    for i = 1:49
        if valid_dn(pos, i)
            push!(moves, (i, i + 14))
        end
        if valid_up(pos, i)
            push!(moves, (i, i - 14))
        end
        if valid_left(pos, i)
            push!(moves, (i, i - 2))
        end
        if valid_right(pos, i)
            push!(moves, (i, i + 2))
        end
    end

    return moves
end

function solution_p(a::Vector{PINS}, b::Vector{PINS})
    return (a == b)
end

function make_move(pos::Vector{PINS}, move::Tuple{Int64,Int64})
    new_pos = copy(pos)

    new_pos[move[1]] = EMPTY;
    new_pos[move[2]] = PIN;
    new_pos[(move[1] + move[2]) ÷ 2] = EMPTY;

    return new_pos
end

function print_pos(pos)
    for i = 1:49
        if pos[i] == INVALID
            print(" ")
        elseif pos[i] == PIN
         print("X")
      elseif pos[i] == EMPTY
        print("O")
        end   
        if (i % 7) == 0
            println("")
        end
    end    
end

function find_solution(spos)
    solution = false
    sol_path = []
    push!(sol_path, spos)

    while !isempty(sol_path) && !solution
        spos = pop!(sol_path)
        solution = solution_p(spos.pos, solution_pos)
        if !solution
            moves = get_moves(spos.pos)
            for move in moves
                npos = position_t([], [])
                npos.pos = make_move(spos.pos, move)
                npos.moves = copy(spos.moves)
                push!(npos.moves, move)
                push!(sol_path, npos)
            end
        else
            println("Length = ", length(spos.moves))
        end
    end

    return (solution, spos)
end

function main()
    start = position_t([], start_pos)
    found, sol = find_solution(start)
    if found
        println("Found solution")
        print_pos(sol.pos)
      # Print solution path
        for move in sol.moves
            println("From ", move[1], " To ", move[2])
        end
    else
        println("There is no solution !")
    end
end

#get_moves(start_pos)

#print_pos(make_move(start_pos, (11, 25)))
#print_pos(make_move(start_pos, (23, 25)))
#print_pos(make_move(start_pos, (27, 25)))
#print_pos(make_move(start_pos, (39, 25)))
#solution_p(start_pos, solution_pos)
#solution_p(solution_pos, solution_pos)

main()
