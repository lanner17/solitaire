
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

solution_pos = [
   INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
   INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
   EMPTY,  EMPTY,  EMPTY,EMPTY,EMPTY,EMPTY,  EMPTY,
   EMPTY,  EMPTY,  EMPTY,PIN,  EMPTY,EMPTY,  EMPTY,
   EMPTY,  EMPTY,  EMPTY,EMPTY,EMPTY,EMPTY,  EMPTY,
   INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
   INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
]

struct position_t
   moves::Vector{Tuple{Int64,Int64}}
   pos::Vector{PINS}
end

function valid_up(pos::Vector{PINS}, pin::Int64)
   endv = pin - 14
   midv = pin - 7
   return  ((endv > 1) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY));
end

function valid_dn(pos::Vector{PINS}, pin::Int64)
   endv = pin + 14;
   midv = pin + 7;
   return  ((endv < 50) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY));
end

function valid_left(pos::Vector{PINS}, pin::Int64)
   endv = pin - 2;
   midv = pin - 1;
   return  ((endv > 1) && ((pin/7) == (endv/7)) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY));
end

function valid_right(pos::Vector{PINS}, pin::Int64)
   endv = pin + 2;
   midv = pin + 1;
   return  ((endv < 47) && ((pin/7) == (endv/7)) && (pos[pin] == PIN) && (pos[midv] == PIN) && (pos[endv] == EMPTY));
end

function get_moves(pos::Vector{PINS})
   moves = []

   for i = 1:50
      if valid_dn(pos, i)
         push!(moves, (i, i+14))

      if valid_up(pos, i)
          push!(moves, (i, i-14))
      
      if valid_left(pos, i)
          push!(moves, (i, i-2))

      if valid_right(pos, i)
         push!(moves, (i, i+2))

   end

   return moves
end

bool solution_p(const vector<enum PINTYPE> &a, const vector<enum PINTYPE> &b)
{
   return (a == b);
}

vector<enum PINTYPE> make_move(const vector<enum PINTYPE> &pos, pair<int,int> &move)
{
   vector<enum PINTYPE> new_pos(pos.begin(), pos.end());

   new_pos[move.first] = EMPTY;
   new_pos[move.second] = PIN;
   new_pos[(move.first + move.second)/2] = EMPTY;

   return new_pos;
}

void print_pos(const vector<enum PINTYPE> &pos)
{
    for ( int i=0 ; i < pos.size() ; i++ )
    {
      if (pos[i] == INVALID)
         cout << " ";
      else if (pos[i] == PIN)
         cout << "X";
      else if (pos[i] == EMPTY)
        cout << "O";

   if (((i+1) % 7) == 0)
        cout << endl;
   }
}

vector< position_t > sol_path;

std::tuple<bool, position_t > find_solution(position_t &spos)
{
   bool solution = false;
   sol_path.push_back(position_t(spos));

   while (!sol_path.empty() && !solution)
   {
      spos = sol_path.back();
      sol_path.pop_back();
      solution = solution_p(spos.pos, solution_pos);
      if (!solution)
      {
         vector< pair<int,int> > moves = get_moves(spos.pos);
         for (auto &move : moves)
         {
            position_t npos = position_t();
            npos.pos = make_move(spos.pos, move);
            copy(spos.moves.begin(), spos.moves.end(), back_inserter(npos.moves));
            npos.moves.push_back(move);
            sol_path.push_back(npos);
        }
      }
      else
      {
         cout << "Length = " << spos.moves.size() << endl;
      }
   }

    return std::make_tuple(solution, spos);
}

int main()
{
   position_t start = position_t();
   start.pos = start_pos;
   auto [found, sol] = find_solution(start);
   if (found)
   {
      cout << "Found solution" << endl;
      print_pos(sol.pos);
      //Print solution path
      for (auto &move : sol.moves)
      {
         cout << "From " << move.first << " To " << move.second << endl;
      }
      
   }
   else
      cout << "There is no solution !" << endl;

   return 0;
}