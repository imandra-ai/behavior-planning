
module Trajectory = struct

    open Vehicle

    (* Trajectory - we incorporate the state into the trajectory calculation *)
    type trajectory = 
        { curr : vehicle_pos; future : vehicle_pos }

    (* Compare two trajectories *)
    let compare_traj (traj_one, traj_two : trajectory * trajectory)
        let traj_one_cost = CostCalculator.calc_cost (traj_one) in 
        let traj_two_cost = CostCalculator.calc_cost (traj_two) in 
        traj_cost (traj_one) < traj_cost (traj_two)

    (*
    def constant_speed_trajectory(self):
        trajectory = [Vehicle(self.lane, self.s, self.v, self.a, self.state), 
                      Vehicle(self.lane, self.position_at(1), self.v, 0, self.state)]
        return trajectory
    *)
    let constant_speed_trajectory (v : vehicle_pos) =
        { curr = v; future = v }
    
    (* 
    def keep_lane_trajectory(self, predictions):
        trajectory = [Vehicle(self.lane, self.s, self.v, self.a, self.state)]
        s, v, a = self.get_kinematics(predictions, self.lane)
        trajectory.append(Vehicle(self.lane, s, v, a, "KL"))
        return trajectory
    *)

    let keep_lane_trajectory (v : vehicle_pos) =
        { curr = v; future = v }
    

    (*
    def prep_lane_change_trajectory(self, predictions, state):
        new_lane = self.lane + lane_direction[state]
        trajectory = [Vehicle(self.lane, self.s, self.v, self.a, self.state)]

        curr_lane_new_kinematics = self.get_kinematics(predictions, self.lane)
        if self.get_vehicle_behind(predictions, self.lane):
            s, v, a = curr_lane_new_kinematics #keep speed of current lane so as not to collide with car behind
        else:
            # choose kinematics with lowest velocity
            next_lane_new_kinematics = self.get_kinematics(predictions, new_lane)
            s, v, a = min([next_lane_new_kinematics, curr_lane_new_kinematics], key=lambda x: x[1])

        trajectory.append(Vehicle(self.lane, s, v, a, state))
        return trajectory
    *)
    let prep_lane_change_trajectory (predictions, state) = 
        { curr = v; future = v }
    
    (*
    def lane_change_trajectory(self, predictions, state):
        #check to make sure the space is free
        new_lane = self.lane + lane_direction[state]
        for vehicle_id, prediction in predictions.items():
            if prediction[0].s == self.s and prediction[0].lane == new_lane:
                return None

        trajectory = [Vehicle(self.lane, self.s, self.v, self.a, self.state)]
        s, v, a = self.get_kinematics(predictions, new_lane)
        trajectory.append(Vehicle(new_lane, s, v, a, state))
        return trajectory
    *)

    let lane_change_trajectory (v : vehicle_pos) = 
        { curr = v; future = v }
    

end
