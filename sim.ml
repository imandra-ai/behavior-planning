
(* Simulation module *)
module RoadSimulation = struct
    
    (* Impacts default behavior for most states *)
    let SPEED_LIMIT = 10 

    (* All traffic in lane (besides ego) follow these speeds *)
    let LANE_SPEEDS = [6,7,8,9] 

    (* Number of available "cells" which should have traffic *)
    let TRAFFIC_DENSITY = 0.15

    (* At each timestep, ego can set acceleration to value between -MAX_ACCEL and MAX_ACCEL *)
    let MAX_ACCEL = 2

    (* 's' value and lane number of goal *)
    let GOAL = (300, 0)

    (* These affect the visualization *)
    let FRAMES_PER_SECOND = 4
    let AMOUNT_OF_ROAD_VISIBLE = 40

    (* Various parameters here -> how should it be done right now??? *)

end