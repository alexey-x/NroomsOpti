/*********************************************
 * OPL 12.9.0.0 Model
 * Author: VOEV
 * Creation Date: Jun 27, 2020 at 4:32:58 PM
 *********************************************/

// important to solve non convex MIQP

execute CPX_PARAM 
{
	cplex.optimalitytarget = 3;
}

 tuple size_t {
	key float EdgeMin;
	key float EdgeMax;
}

{size_t} len_dat = ...;
{size_t} wid_dat = ...;


float len = ...; // length
float wid = ...; // width

range Nroom = 1..card(len_dat);

size_t edge_len[Nroom];
size_t edge_wid[Nroom];
execute fill_sizes {
	var i = 1;
	for(var s in len_dat){
		edge_len[i] = s;
		i++;
	}
	var i = 1;
	for(var s in wid_dat){
		edge_wid[i] = s;
		i++;
	}
}


// perimeter
//dexpr float objective = sum(i in Nroom) (dx[i] + dy[i]);


// ---  model ----

dvar float+ x[Nroom]; // x-- use with length
dvar float+ dx[Nroom];
dvar float+ y[Nroom]; // y -- use with width
dvar float+ dy[Nroom]; 

dvar boolean bx[Nroom][Nroom]; // need for no intersection condition
dvar boolean by[Nroom][Nroom]; // need for no intersection condition

// non convex 
dexpr float objective = sum(i in Nroom) (dx[i] * dy[i]);

maximize objective;

subject to {
	forall(i in Nroom){
		ctTotLenWid:
		x[i] + dx[i] <= len;
		y[i] + dy[i] <= wid;
		//
		dx[i] >= edge_len[i].EdgeMin;
		dx[i] <= edge_len[i].EdgeMax;
		dy[i] >= edge_wid[i].EdgeMin;
		dy[i] <= edge_wid[i].EdgeMax;
	}	
	forall(i, j in Nroom){
		ctNoIntersection:
		if( i != j ){
			x[i] + dx[i] - x[j] <= len * (1 - bx[i][j]);
			x[j] + dx[j] - x[i] <= len * (1 - bx[j][i]);
		
			y[i] + dy[i] - y[j] <= wid * (1 - by[i][j]);
			y[j] + dy[j] - y[i] <= wid * (1 - by[j][i]);
		
			bx[i][j] + bx[j][i] + by[i][j] + by[j][i] == 1;
		}
		else{
			bx[i][j] == 0;
			by[i][j] == 0;		
		}		
	}
}

// -- output to excel

tuple out_t {
	int room;
	float x;
	float y;
	float a;
}

{out_t} solution = 
	{<i, x[i], y[i], dx[i]*dy[i]> | i in Nroom}
	union
	{<i, x[i]+dx[i], y[i], 0.> | i in Nroom}
	union
	{<i, x[i]+dx[i], y[i]+dy[i], 0.> | i in Nroom}
	union
	{<i, x[i], y[i]+dy[i], 0.> | i in Nroom}
;

execute PRINT_AREA
{
	var area = 0;
	for(var i in Nroom)
	{
		writeln(i, "area =  ", dx[i]*dy[i]);
		area +=  dx[i]*dy[i]	
	}
	writeln("Total area: ", area);
}
