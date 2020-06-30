# NroomsOpti
Given linear sizes of N rooms fill by them some rectangular space.

## Task, assumptions and data

1. The main (big) room has rectangular shape with known linear sizes (see data/main_room).
2. There are N small rooms to place in the main room.
3. The range of linear sizes of each room is given (see data/rooms_lin_sizes).
4. The walls of small rooms are paralell to the ones of the main room.
5. Rooms have 4 corners.
6. Make the areas of N rooms as much as possible, do not cross the bounds of the main rooms, rooms can not overlap.

### Notes

1. No overlapping conditions are in 00_no_overlap.ipynb
2. ILOG non-linear task is in ilog
3. Simple solution visualization in 01_ilog_out.ipynb
