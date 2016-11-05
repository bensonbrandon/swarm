classdef Agent<handle
    %AGENT a unit that interacts with others through force and internal
    %control
    %   Agents have positions and velocity in space.  they are also feel
    %   forces from other agents and react to them based on an intelligent
    %   internal controller.  This controller can learn from figures of
    %   merit provided by the environment.
    
    properties
        pos %[positionX,positionY] vector
        vel %[velocityX,velocityY] vector
        cont %controller parameter
        loc %locaity function handle, typically 1/r
        
        b %from environment variable [b,c,shake,color,size] 
        c %b,c are parameters for damping and force amplitude
        shake
        color %used for identifying allies and enemies
        size %size of an agent, typically .02
    end
    
    methods
        function obj = Agent(pos,vel,cont,loc,envir)
            obj.pos = pos;
            obj.vel = vel;
            obj.cont = cont;
            obj.loc = loc;
            obj.b = envir(1);
            obj.c = envir(2);
            obj.shake = envir(3);
            obj.color = envir(4);
            obj.size = envir(5);
            
        end
        
        function obj = step(obj,infoAlly,infoEnemy)
            infoAx = infoAlly(1);
            infoAy = infoAlly(2);
            infoEx = infoEnemy(1);
            infoEy = infoEnemy(2);
            x = obj.pos(1);
            y = obj.pos(2);
            vx = obj.vel(1);
            vy = obj.vel(2);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %   convert info to force 
            %   (maps interval (0,1) in info to (0,1) in force)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            forcex = infoEx - infoAx;
            sgn = sign(forcex);
            forcex = abs(forcex);
            maxf = 1;
            if forcex > maxf
                forcex = obj.cont(end);
            else
                forcex = interp1(linspace(0,maxf,length(obj.cont)),obj.cont,forcex);
            end
            forcex = sgn*forcex;
            
            forcey = infoEy - infoAy;
            sgn = sign(forcey);
            forcey = abs(forcey);
            maxf = 1;
            if forcey > maxf
                forcey = obj.cont(end);
            else
                forcey = interp1(linspace(0,maxf,length(obj.cont)),obj.cont,forcey);
            end
            forcey = sgn*forcey;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %   update position
            %   (uses calculated forces and environment parameters to
            %   update position and velocity vectors)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xnew = 1/(obj.b+1) *obj.c*forcex + x + (1/(obj.b+1))*vx + obj.shake*(rand-.5);
            ynew = 1/(obj.b+1) *obj.c*forcey + y + (1/(obj.b+1))*vy + obj.shake*(rand-.5);
            obj.vel = [xnew - x, ynew - y];
            obj.pos = [xnew,ynew];
            
        end
            
    end
    
end

