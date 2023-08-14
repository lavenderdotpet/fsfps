void() waypoint_clear =
{
	self.waycost = 0;
	self.bookedent = world;
};

void(vector where, float radius, float dangerlevel, float dangertime) danger =
{
	local entity ent;

	ent = findradius(where, radius);

	while(ent)
	{
		if (ent.classname == "waypoint")
		{
			ent.waycost = ent.waycost + dangerlevel;
			ent.think = waypoint_clear;
			if (ent.nextthink > time)
				ent.nextthink = ent.nextthink + dangertime;
			else
				ent.nextthink = time + dangertime;
		}

		ent = ent.chain;
	}
};

void(entity current, entity link) waypoint_check =
{
	local float g;

	if (link.waylist == WAY_CLOSED)
		return;

	if (link == world)
		return;
	
	g = current.gcost + vlen(current.origin - link.origin);
	if (link.bookedent != self)
		g = g + (g * link.waycost);

	if ((link.waylist == WAY_EMPTY) || (g < link.gcost))
	{
		link.waylist = WAY_OPEN;
		link.wayparent = current;
		link.gcost = g;
		link.fcost = link.gcost + link.hcost;
	}
};

entity() lowest_f =
{
	local entity ent, best;
	local float flo;

	flo = 999999;

	ent = findchainfloat(waylist, WAY_OPEN);

//	ent = findfloat(world, waylist, WAY_OPEN);
	while(ent)
	{
		if (ent.fcost < flo)
		{
			flo = ent.fcost;
			best = ent;
		}
//		ent = findfloat(ent, waylist, WAY_OPEN);
		ent = ent.chain;
	}
	
	return best;
}

entity(entity endy) nearestway =
{
	local float flo;
	local entity ent, best;
	local vector vec;

	vec = endy.origin;

	flo = 500;

	ent = findradius(endy.origin, flo);

	while(ent)
	{
		if (ent.waynum)
		{
			if (vlen(ent.origin - vec) < flo)
			{
				if (canwalk(self, vec, VEC_HULL_MIN, VEC_HULL_MAX, ent.origin))
				{
					best = ent;
					flo = vlen(ent.origin - vec);
				}
			}
		}
		ent = ent.chain;
	}

	return best;
};

entity() a_star =
{
	saferoute = TRUE;

	if (wpframe)
		return self;

	local entity ent, tempway, current;
	local string str;
	local float flo, t;

	ent = find(world, classname, "waypoint");

	if (ent == world)
		return self.objective;

	if (canwalk(self.objective, self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.objective.origin))
		return self.objective;

	while(ent)
	{	
		ent.wayparent = world;
		ent.waylist = WAY_EMPTY;
		ent.gcost = 0;
		ent.fcost = 0;
		ent.hcost = vlen(ent.origin - self.objective.origin);
		if (ent.waynum > flo)
			flo = ent.waynum;
		ent = find(ent, classname, "waypoint");
	}

	self.startnode = nearestway(self);
	self.endnode = nearestway(self.objective);

	if (self.startnode == self.endnode)
	{
		return self.objective;
	}
	if ((self.startnode == world) || (self.endnode == world))
	{
		return self.objective;
	}

	current = self.startnode;
	current.waylist = WAY_OPEN;

	while(current != self.endnode)
	{
		current = lowest_f();
//		fprint(current.waynum);
		if (current == world)
			break;

		current.waylist = WAY_CLOSED;
		
		waypoint_check(current, current.link1);
		waypoint_check(current, current.link2);
		waypoint_check(current, current.link3);
		waypoint_check(current, current.link4);
		waypoint_check(current, current.link5);
		waypoint_check(current, current.link6);	
	}


	while((current.wayparent != self.startnode) && (current.wayparent != world) && (vlen(current.wayparent.origin - self.origin) > 100))
	{
		tempway = current;
		current = current.wayparent;
	}

	if (tempway)
	{
		if (!tempway.waycost)
		{
			tempway.waycost = 10;
			tempway.bookedent = self;
			tempway.think = waypoint_clear;
			tempway.nextthink = time + 5;
		}
	}

	wpframe = TRUE;

	if (current.waycost > 50)
	{
		saferoute = FALSE;
		return self;
	}

	return current;
};


void(float dist) t_movetogoal2 =
{
	if (walkmove(self.angles_y, dist))
	{
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		ChangeYaw();
	}
	else
		movetogoal(dist);
};

void(float dist) t_movetogoal =
{
	local float mn, dis, flo, f;
	local entity ent, cho;
	local vector vec;

	f = dist;
	mn = dis = 200;
	
	ent = findradius(self.origin, mn);

	while(ent)
	{
		if ((ent.health > 0) || (ent.classname == "grenade"))
		{
			flo = vlen(ent.origin - self.origin);
			if (flo < mn)
			{
				mn = flo;
				cho = ent;
			}
		}
		ent = ent.chain;
	}

	if (cho == world)
		vec = self.goalentity.origin;
	else
	{
		vec = cho.origin - self.origin;
		dist = vlen (vec);
		dist = (dis - dist) * 5;
		vec = normalize(vec);
		vec = self.origin - (vec * dist);
		
		vec = (vec + self.goalentity.origin) * 0.5;

		dist = vlen(self.goalentity.origin - self.origin);

		if (dist < 300)
			vec = self.goalentity.origin;
	}

	
	if (walkmove(self.angles_y, f))
	{
		self.ideal_yaw = vectoyaw(vec - self.origin);
		ChangeYaw();
	}
	else
		movetogoal(f);
};