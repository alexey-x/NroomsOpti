/*********************************************
 * OPL 12.9.0.0 Model
 * Author: VOEV
 * Creation Date: Jun 27, 2020 at 10:51:37 AM
 *********************************************/


 range Nroom = 1..3;
 
 tuple ix_t {
 	int i;
 	int j; 
 }
 
 {ix_t} ix = {<i, j> | i in Nroom, j in Nroom: i != j};
 
 execute {
 	writeln(ix); 
 }