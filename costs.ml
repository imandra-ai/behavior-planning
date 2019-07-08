
(* Module for calculating trajectory costs *)

module CostCalculator = struct

    open Vehicle

    (* Total cost together with components - note that the total cost number includes weights as well *)
    type cost = {
        cost_efficiency : real;
        cost_goal_reach : real;
        cost_total      : real;
    }

    (* These should be configured externally. *)
    let w_inefficiency = 0.1
    let w_goal_reach   = 0.9

(* def goal_distance_cost(vehicle, trajectory, predictions, data):
    """
    Cost increases based on distance of intended lane (for planning a lane change) and final lane of trajectory.
    Cost of being out of goal lane also becomes larger as vehicle approaches goal distance.
    """
    distance = abs(data.end_distance_to_goal)
    if distance:
        cost = 1 - 2*exp(-(abs(2.0*vehicle.goal_lane - data.intended_lane - data.final_lane) / distance))
    else:
        cost = 1
    return cost *)

    let goal_distance_cost (v, trajectory, predictions, data : vehicle * trajectory * int list * int) = 
        let distance = abs (data.end_distance_to_goal) in 
        if data > 0 then 
            1.0 - 2.0 * exp(-(abs(2.0 * vehicle.goal_lane - data.intended_lane - data.final_lane) /. distance)) 
        else  
            1.0

(*
def inefficiency_cost(vehicle, trajectory, predictions, data):
    """
    Cost becomes higher for trajectories with intended lane and final lane that have slower traffic. 
    """

    proposed_speed_intended = velocity(predictions, data.intended_lane) or vehicle.target_speed
    proposed_speed_final = velocity(predictions, data.final_lane) or vehicle.target_speed
    
    cost = float(2.0*vehicle.target_speed - proposed_speed_intended - proposed_speed_final)/vehicle.target_speed
    return cost
*)
    let inefficiency_cost(vehicle, trajectory predictions, data) = 
        let proposed_speed_intended = 
            let res = velocity(predictions, data.intended_lane) in 
            match res with 
            | None -> vehicle.target_speed
            | Some s -> s in
        let proposed_speed_final = 
            let res = velocity(predictions, data.final_lane) in
            match res with 
            | None -> vehicle.target_speed
            | Some s -> s in
        
        (* This is the actual iefficiency cost calculation *)
        (2.0 *. vehicle.target_speed -. proposed_speed_intended -. proposed_speed_final) /. vehicle.target_speed
    
    let calc_cost (v, traj, predicts : vehicle * trajectory * predictions) =
        let traj_data = get_helper_data(v, traj, predictions) in
        
        let c_eff = inefficiency_cost () in
        let c_goal = calc_goal_cost () in

        let cost = w_inefficiency *. c_eff +. w_goal_reach *. c_goal in {
            cost_efficiency = c_eff;
            cost_goal_reach = c_goal;
            cost_total      = cost;
        }

(*
def get_helper_data(vehicle, trajectory, predictions):
    """
    Generate helper data to use in cost functions:
    indended_lane: the current lane +/- 1 if vehicle is planning or executing a lane change.
    final_lane: the lane of the vehicle at the end of the trajectory.
    distance_to_goal: the distance of the vehicle to the goal.

    Note that indended_lane and final_lane are both included to help differentiate between planning and executing
    a lane change in the cost functions.
    """

    last = trajectory[1]

    if last.state == "PLCL":
        intended_lane = last.lane + 1
    elif last.state == "PLCR":
        intended_lane = last.lane - 1
    else:
        intended_lane = last.lane

    distance_to_goal = vehicle.goal_s - last.s
    final_lane = last.lane

    return TrajectoryData(
        intended_lane,
        final_lane,
        distance_to_goal)
*) 

    (** 
        get_helper_data

        Generate helper data to use in cost functions:
        indended_lane: the current lane +/- 1 if vehicle is planning or executing a lane change.
        final_lane: the lane of the vehicle at the end of the trajectory.
        distance_to_goal: the distance of the vehicle to the goal.

        Note that indended_lane and final_lane are both included to help differentiate between planning and executing
        a lane change in the cost functions.
    *)

    (* This is a useful data type to provide helper info for calculating trajectories' costs. *)
    type traj_helper_data = {
        t_intende_lane : int;
        t_final_lane : int;
        t_distance_to_goal : int;
    }

    let get_helper_data (v, traj, predictions : vehicle * trajectory * predictions) = 
        let intended_lane = match last with 
        | PLCL -> last.lane + 1
        | PLCR -> last.lane - 1
        | _ -> last.lane in
        let distance_to_goal = vehicle.goal_s - last.s in
        let final_lane = last.lane in
        { intended_lane = intended_lane; final_lane = final_lane; distance_to_goal = distance_to_goal }
