#include <iostream>
#include <vector>
#include <utility>

using std::cin;
using std::cout;
using std::endl;
using std::vector;
using std::pair;

enum PINTYPE
{
    INVALID,
    EMPTY,
    PIN,
};

vector<enum PINTYPE> start_pos = {
    INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
    INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
    PIN,    PIN,    PIN,PIN,  PIN,PIN,    PIN,
    PIN,    PIN,    PIN,EMPTY,PIN,PIN,    PIN,
    PIN,    PIN,    PIN,PIN,  PIN,PIN,    PIN,
    INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
    INVALID,INVALID,PIN,PIN,  PIN,INVALID,INVALID,
};

vector<enum PINTYPE> solution_pos = {
    INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
    INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
    EMPTY,  EMPTY,  EMPTY,EMPTY,EMPTY,EMPTY,  EMPTY,
    EMPTY,  EMPTY,  EMPTY,PIN,  EMPTY,EMPTY,  EMPTY,
    EMPTY,  EMPTY,  EMPTY,EMPTY,EMPTY,EMPTY,  EMPTY,
    INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
    INVALID,INVALID,EMPTY,EMPTY,EMPTY,INVALID,INVALID,
};

typedef struct position
{
    vector< pair<int,int> > moves;
    vector<enum PINTYPE> pos;
} position_t;

bool valid_up(const vector<enum PINTYPE> &pos, int pin)
{
    int end = pin - 14;
    int mid = pin - 7;
    return  ((end > 1) && (pos[pin] == PIN) && (pos[mid] == PIN) && (pos[end] == EMPTY));
}

bool valid_dn(const vector<enum PINTYPE> &pos, int pin)
{
    int end = pin + 14;
    int mid = pin + 7;
    return  ((end < 47) && (pos[pin] == PIN) && (pos[mid] == PIN) && (pos[end] == EMPTY));
}

bool valid_left(const vector<enum PINTYPE> &pos, int pin)
{
    int end = pin - 2;
    int mid = pin - 1;
    return  ((end > 1) && ((pin/7) == (end/7)) && (pos[pin] == PIN) && (pos[mid] == PIN) && (pos[end] == EMPTY));
}

bool valid_right(const vector<enum PINTYPE> &pos, int pin)
{
    int end = pin + 2;
    int mid = pin + 1;
    return  ((end < 47) && ((pin/7) == (end/7)) && (pos[pin] == PIN) && (pos[mid] == PIN) && (pos[end] == EMPTY));
}

auto get_moves(const vector<enum PINTYPE> &pos)
{
    vector< pair<int,int> > moves;

    for (int i=0; i<pos.size(); i++)
    {
        if (valid_dn(pos, i))
        {
            moves.push_back(std::make_pair(i, i+14));
        }
        if (valid_up(pos, i))
        {
            moves.push_back(std::make_pair(i, i-14));
        }
        if (valid_left(pos, i))
        {
            moves.push_back(std::make_pair(i, i-2));
        }
        if (valid_right(pos, i))
        {
            moves.push_back(std::make_pair(i, i+2));
        }
    }
    return moves;
}

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

vector< vector<enum PINTYPE> > sol_path;

void find_solution(const vector<enum PINTYPE> &pos)
{

    if (solution_p(pos, solution_pos))
    {
        cout << "found solution" << endl;
        cout << "Solution path length = " <<  sol_path.size() << endl;
        print_pos(pos);
    }
    else
    {
        vector< pair<int,int> > moves = get_moves(pos);
        for (auto &move : moves)
        {
            sol_path.push_back(make_move(pos, move));
        }
        
        if (!sol_path.empty())
        {
            auto posi = sol_path.back();
            sol_path.pop_back();
            find_solution(posi);
        }
        else
        {
            cout << "There is no solution" << endl;
        }
    }
}

int main()
{
    vector< pair<int,int> > moves = get_moves(start_pos);
    cout << "Size : " << moves.size() << endl;
    
    find_solution(start_pos);
    return 0;
}