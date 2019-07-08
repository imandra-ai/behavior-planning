(* 


*)

module Vehicle = struct

    (* Time is in seconds for simplicity *)
    type time = int

    (* Vehicle mode *)
    type mode = 
        | CS (* Keep speed *)
        | KL (* Keep lane *) 
        | PLCL (* Prepare lane change left *) 
        | LCL (* Left change left *) 
        | LCR (* Left change right *)
        | PLCR (* Prepare lane change right *)

    (* This will help us compute new lanes *)
    let lane_direction = function
        | PLCL | LCL -> 1
        | LCR | PLCR -> -1
        | KL | CS -> 0

    (* Vehicle state - all of the information about the vehicle
    we would ever need. *)
    type vehicle = {
        (* Current mode of the vehicle *)
        v_state : mode;

        (* Position, lane, velocity and acceleration information *)
        v_pos : vehicle_pos;
        
        (* Configuration for curren maneuver *)
        v_max_acceleration : int;
        v_lanes_available : int;

        (* These 3 form the definition of our goal. *)
        v_target_speed : int;
        v_goal_lane :int;
        v_goal_s : int;
    }

    (* Calculation position of a vehicle 
        Predicts position of vehicle in t seconds. Used in incrementing
        vehicle positions and also trajectory generation. *)
    let position_at (v_pos, t : vehicle_pos * time) =
        (* Return a type of vehicle position *)
        { v_pos with s = v.v_s + v.v_v * t + v.v_a * t * t / 2 }
    
    (* Get prediction - notice that the most future-dated estimate will
        be the 1st element of the resulting list. *)
    let get_predictions (v, horizon : vehicle * horizon) =
        if horizon <= 0 then []
        else
            let new_pos = position_at (v.v_pos, h) in
            let v' = { v with v_pos = new_pos } in
            v' :: (get_predictions (v', horizon - 1))

(* def generate_predictions(self, horizons=2):
        """
        Generates predictions for non-ego vehicles to be used
        in trajectory generation for ego vehicle.
        """

        predictions = []
        for i in range(horizon):
            s = self.position_at(i)
            v = 0
            if(i < horizon-1):
                v = self.position_at(i+1) - s
            predictions.append(Vehicle(self.lane, s, v, 0))
        return predictions
*) 
    (* *)

    (* 
        states = self.successor_states()
        costs = []
        for state in states:
            trajectory = self.generate_trajectory(state, predictions)
            if trajectory:             
                cost = calculate_cost(self, trajectory, predictions)
                costs.append({"cost" : cost, "state": state, "trajectory": trajectory})
        best = min(costs, key=lambda s: s['cost'])
        return best["trajectory"]
    *)

    (* This will select the best trajectory based on the available ones right now
        and update the state. 
 Provides the possible next states given the current state for the FSM discussed in the course,
        with the exception that lane changes happen instantaneously, so LCL and LCR can only transition back to KL.
        """
        if self.state == "KL":
            states = ["KL", "PLCL", "PLCR"]
        elif self.state == "PLCL":
            states = ["KL"]
            if self.lane != (self.lanes_available-1):
                states.append("PLCL")
                states.append("LCL")
        elif self.state == "PLCR":
            states = ["KL"]
            if self.lane != 0:
                states.append("PLCR")
                states.append("LCR")
        elif self.state in ("LCL", "LCR"):
            states = ["KL"]
        return states
*)

    (* Note that lane changes are instantenous, hence we're not 
    providing it there. *)
    let one_step (v: vehicle) = 
        match v.v_state with
        | KL | LCL | LCR -> { v with v_mode = KL }
            (* If we're keeping lane, then we return keep lane trajectory. 
                Note that in this model, actual lane changes are instanteneous. *)
        | PLCL -> 
            begin
                let kl_traj = calc_KL_traj () in
                if v.v_pos.lane_id <> 1 then
                else
                    begin
                        let plcl_traj = calc_PLCL_traj () in
                        let lcl_traj = calc_LCL_traj () in 
                    end
                (* let's calculate the *)
            end 
            (* v 
                If we're in PrepareLeftChangeLange mode, then we can 
            *) 
        | PLCR -> v

end
