(* Vehicle module *)

(* Vehicle position - separate from state as 
    this is used in multiple places where we do not need the 
    whole state.  *)

type vehicle_pos = {
    lane_id : int; (* Lane ID *)
    v_s : int; (* Position *)
    v_v : int; (* Velocity *)
    v_a : int; (* Acceleration *)
}


(*
def velocity(predictions, lane):
    """
    All non ego vehicles in a lane have the same speed, so to get the speed limit for a lane,
    we can just find one vehicle in that lane.
    """
    for v_id, predicted_traj in predictions.items():
        if predicted_traj[0].lane == lane and v_id != -1:
            return predicted_traj[0].v
*)

    (* All non-ego vehicles in a lane have the same speed, so to get the speed limit for a lane,
    we can just find one vehicle in that lane. *)
    let velocity (predictions : lane) =
        match predictions with
        | [] -> None (* What if there are no vehicles here? *)
        | x::xs -> Some x.v_pos.v_v 

    
end 

(* Road module *)
module Road = struct

    type vehicle = {
        v_id : int;
        v_speed : int;
        v_pos : int;
    }

    type ego_position = {
        lane_id : int;
        vehicle_id : int;
    }

    type lane = vehicle list

    (* Update lane vehicles with their positions *)
    let rec update_lane l =
        match l with
        | [] -> []
        | x::xs -> { x with v_pos = x.v_pos + x.v_speed } :: (update_lane xs)

(*  def get_kinematics(self, predictions, lane):
        """
        Gets next timestep kinematics (position, velocity, acceleration) for a given lane.
        Tries to choose the maximum velocity and acceleration, given other vehicle positions and accel/velocity constraints.
        """
        max_velocity_accel_limit = self.max_acceleration + self.v
        vehicle_ahead = self.get_vehicle_ahead(predictions, lane)
        vehicle_behind = self.get_vehicle_behind(predictions, lane)

        if vehicle_ahead:
            if vehicle_behind:
                #must travel at the speed of traffic, regardless of preferred buffer
                new_velocity = vehicle_ahead.v

            else:
                #choose max velocity and acceleration that leaves desired buffer in front
                #Equation: front buffer <= (vcl.s - ego.s) + (vcl.v - ego.v)*t + 0.5 * (vcl.a - ego.a)*t*t
                max_velocity_in_front = (vehicle_ahead.s - self.s - self.preferred_buffer) + vehicle_ahead.v - 0.5 * self.a
                new_velocity = min(max_velocity_in_front, max_velocity_accel_limit, self.target_speed)

        else:
            new_velocity = min(max_velocity_accel_limit, self.target_speed)

        new_accel = new_velocity - self.v #Equation: (v_1 - v_0)/t = acceleration
        new_position = self.s + new_velocity + new_accel / 2.0
        return new_position, new_velocity, new_accel
*)
    type kinematics = {
        k_position : int;
        k_velocity : int;
        k_accelration : int;
    }

    (* Return kinematics for a given lane
        Gets next timestep kinematics (position, velocity, acceleration) for a given lane.
        Tries to choose the maximum velocity and acceleration, given other vehicle positions and accel/velocity constraints.
     *)
    let get_lane_kinematics (l,  : lane) = 

        (* Make predictions on where the vehicles are expected to be *)
        let prediction = 

end

