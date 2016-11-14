classdef ArmyAgent<handle
    %AGENT a unit that interacts with others through force and internal
    %control
    %   Agents have positions and velocity in space.  they are also feel
    %   forces from other agents and react to them based on an intelligent
    %   internal controller.  This controller can learn from figures of
    %   merit provided by the environment.
    
    properties
        pos %[positionX,positionY] vector
        vel %[velocityX,velocityY] vector
        
        b %from environment variable [b,c,shake,color,size] 
        c %b,c are parameters for damping and force amplitude
        shake
        color %used for identifying allies and enemies
        size %size of an agent, typically .02
        fixed
        initialState
        contParaUpdate
    end
    
    methods
        function obj = ArmyAgent(pos,vel,cont,envir)
            obj.pos = pos;
            obj.vel = vel;
            obj.b = envir(1);
            obj.c = envir(2);
            obj.shake = envir(3);
            obj.color = envir(4);
            obj.size = envir(5);
            obj.fixed = 0;
            obj.initialState = {pos,vel}; %initPos,initVel
            obj.contParaUpdate = {0,cont,Inf,cont}; %stepN, cont, laststepN, lastCont
        end
        
        function obj = step(obj,forcex,forcey)
            if obj.fixed
                return
            end
            obj.contParaUpdate{1} = obj.contParaUpdate{1} + 1;
            x = obj.pos(1);
            y = obj.pos(2);
            vx = obj.vel(1);
            vy = obj.vel(2);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %   update position
            %   (uses forces and environment parameters to
            %   update position and velocity vectors)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xnew = 1/(obj.b+1) *obj.c*forcex + x + (1/(obj.b+1))*vx + obj.shake*(rand-.5);
            ynew = 1/(obj.b+1) *obj.c*forcey + y + (1/(obj.b+1))*vy + obj.shake*(rand-.5);
            obj.vel = [xnew - x, ynew - y];
            obj.pos = [xnew,ynew];
            
        end    
        
        function obj = fix(obj,position)
            %if this is called, the object cannot move for the remainder of
            %the simulation
            obj.fixed = 1;
            obj.pos = position;
            
            %automatically update the controller based on the information
            %that it recieved.
            
            stepN = obj.contParaUpdate{1};
            control = obj.contParaUpdate{2};
            lastStepN = obj.contParaUpdate{3};
            lastControl = obj.contParaUpdate{4};
            pertControl = .1*(.5-rand(1,length(control)));
            if stepN < lastStepN
            	obj.contParaUpdate{3} = stepN; %update last steps
                obj.contParaUpdate{4} = control; %update last cont
                obj.contParaUpdate{1} = 0;
                %random permutation of control parameters.
                
                obj.contParaUpdate{2} = obj.contParaUpdate{2} + pertControl;
            else
                obj.contParaUpdate{1} = 0;
                obj.contParaUpdate{2} = lastControl + pertControl;
            end
        end
        
        function obj = reset(obj)
            obj.fixed = 0;
            obj.pos = obj.initialState{1};
            obj.vel = obj.initialState{2};
        end
    end
    
end

