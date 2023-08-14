void(float flo) fprint =
{
	local string str;

	str = ftos(flo);
	bprint(str);
	bprint("\n");
};

float(entity ent, entity ant) way_linked =
{
	if ((ent == world) || (ant == world))
		return TRUE;

	if (ent.link1 == ant)
		return TRUE;
	if (ent.link2 == ant)
		return TRUE;
	if (ent.link3 == ant)
		return TRUE;
	if (ent.link4 == ant)
		return TRUE;
	if (ent.link5 == ant)
		return TRUE;
	if (ent.link6 == ant)
		return TRUE;

	return FALSE;
};

void(entity ent, entity ant) way_unlink =
{
	if ((ent == world) || (ant == world))
		return;

	if (ent.link1 == ant)
	{
		ent.lk1 = 0;
		ent.link1 = world;
	}
	if (ent.link2 == ant)
	{
		ent.lk2 = 0;
		ent.link2 = world;
	}
	if (ent.link3 == ant)
	{
		ent.lk3 = 0;
		ent.link3 = world;
	}
	if (ent.link4 == ant)
	{
		ent.lk4 = 0;
		ent.link4 = world;
	}
	if (ent.link5 == ant)
	{
		ent.lk5 = 0;
		ent.link5 = world;
	}
	if (ent.link6 == ant)
	{
		ent.lk6 = 0;
		ent.link6 = world;
	}

	if (ant.link1 == ent)
	{
		ant.lk1 = 0;
		ant.link1 = world;
	}
	if (ant.link2 == ent)
	{
		ant.lk2 = 0;
		ant.link2 = world;
	}
	if (ant.link3 == ent)
	{
		ant.lk3 = 0;
		ant.link3 = world;
	}
	if (ant.link4 == ent)
	{
		ant.lk4 = 0;
		ant.link4 = world;
	}
	if (ant.link5 == ent)
	{
		ant.lk5 = 0;
		ant.link5 = world;
	}
	if (ant.link6 == ent)
	{
		ant.lk6 = 0;
		ant.link6 = world;
	}
};

void(entity ent, entity ant) way_link =
{
	if ((ent == world) || (ant == world))
		return;

	if (ent.link1 == world)
	{
		ent.lk1 = ant.waynum;
		ent.link1 = ant;
	}
	else if (ent.link2 == world)
	{
		ent.lk2 = ant.waynum;
		ent.link2 = ant;
	}
	else if (ent.link3 == world)
	{
		ent.lk3 = ant.waynum;
		ent.link3 = ant;
	}
	else if (ent.link4 == world)
	{
		ent.lk4 = ant.waynum;
		ent.link4 = ant;
	}
	else if (ent.link5 == world)
	{
		ent.lk5 = ant.waynum;
		ent.link5 = ant;
	}
	else if (ent.link6 == world)
	{
		ent.lk6 = ant.waynum;
		ent.link6 = ant;
	}
	else 
	{
//		bprint("Cannot link, too many links\n");
		return;
	}

	if (ant.link1 == world)
	{
		ant.lk1 = ent.waynum;
		ant.link1 = ent;
	}
	else if (ant.link2 == world)
	{
		ant.lk2 = ent.waynum;
		ant.link2 = ent;
	}
	else if (ant.link3 == world)
	{
		ant.lk3 = ent.waynum;
		ant.link3 = ent;
	}
	else if (ant.link4 == world)
	{
		ant.lk4 = ent.waynum;
		ant.link4 = ent;
	}
	else if (ant.link5 == world)
	{
		ant.lk5 = ent.waynum;
		ant.link5 = ent;
	}
	else if (ant.link6 == world)
	{
		ant.lk6 = ent.waynum;
		ant.link6 = ent;
	}
	else 
	{
//		bprint("Cannot link, too many links\n");
		return;
	}
};

entity(float lk) way_numlink =
{
	local entity ent;
	
	if (lk == 0)
		return world;
	
	ent = find(world, classname, "waypoint");
	while (ent)
	{
		if (ent.waynum == lk)
			return ent;
		ent = find(ent, classname, "waypoint");
	}
	return world;
};

void() waypoint_begin = 
{
	self.link1 = way_numlink(self.lk1);
	self.link2 = way_numlink(self.lk2);
	self.link3 = way_numlink(self.lk3);
	self.link4 = way_numlink(self.lk4);
	self.link5 = way_numlink(self.lk5);
	self.link6 = way_numlink(self.lk6);

//	droptofloor();
};

float(entity way, entity ent) canwalk2 =
{
	local entity blank, oldself;
	local vector wayorg, entorg;
	local float far, ang, i;

	blank = spawn();
	blank.solid = SOLID_SLIDEBOX;
	blank.movetype = MOVETYPE_STEP;
	setmodel(blank, "progs/soldier.mdl");
	setsize(blank, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(blank, way.origin);

	wayorg = way.origin;
	wayorg_z = 0;
	entorg = ent.origin;
	entorg_z = 0;

	far = vlen(wayorg - entorg);

	ang = vectoyaw(ent.origin - way.origin);
	
	oldself = self;
	self = blank;

	droptofloor();
	walkmove(ang, far);
	
	self = oldself;

	if (vlen(blank.origin - ent.origin) < 50)
	{
		far = vlen(blank.origin - ent.origin);
		fprint(far);
		i = 1;
	}

	remove(blank);

	return i;
};

float (entity e, vector start, vector m1, vector m2, vector end) canwalk =
{
	local vector org;
	local vector move;
	local vector dir;
	local float dist;
	local float totaldist;
	local float stepdist;
	local float yaw;
	local float ignorehazards;
	local vector stepheightvec;

	stepheightvec = cvar("sv_stepheight") * '0 0 1';

	move = end - start;
	move_z = 0;
	org = start;
	dist = totaldist = vlen(move);
	dir = normalize(move);
	stepdist = 16;
	
	traceline(start, start, MOVE_NORMAL, e);
	tracebox(start, m1, m2, start, MOVE_NOMONSTERS, e);
	if (trace_startsolid)
		return 0;
	yaw = vectoyaw(move);
	move = end - org;
	while (1)
	{
		if (vlen(org - end) < 25)
			return 1;
		if (dist <= 0)
			break;

		if (stepdist > dist)
			stepdist = dist;
		dist = dist - stepdist;
		traceline(org, org, MOVE_NORMAL, e);

		move = dir * stepdist + org;
		tracebox(org, m1, m2, move, MOVE_NORMAL, e);
		if (trace_fraction < 1)
		{
			tracebox(org + stepheightvec, m1, m2, move + stepheightvec, MOVE_NORMAL, e);
			if (trace_fraction < 1 || trace_startsolid)
			{
				return 0;
			}
		}


		move = trace_endpos;
		tracebox(move, m1, m2, move - stepheightvec, MOVE_NORMAL, e);
		if (trace_fraction == 1)
			return 0;

		org = trace_endpos;
	}

	return 0;
};

void(entity ent) find_autolinks =
{
	local entity way, clo;
	local float dist, ordered;

	way = findradius(ent.origin, 750);
		
	while(way)
	{
		if (way.classname == "waypoint")
		{
			if(way != ent)
			{
				if (!way_linked(way, ent))
				{
					if (canwalk(self, way.origin, VEC_HULL_MIN, VEC_HULL_MAX, ent.origin))
					{
						way.waytagged = TRUE;
						way.waydist = vlen(way.origin - ent.origin);
					}
				}
			}
		}
		way = way.chain;
	}

	while(!ordered)
	{
		clo = world;
		dist = 750;
		way = findfloat(world, waytagged, TRUE);

		if (!way)
			ordered = TRUE;

		while(way)
		{
			if (way.waydist < dist)
			{
				clo = way;
				dist = way.waydist;
			}
			way = findfloat(way, waytagged, TRUE);
		}

		if (!clo)
			ordered = TRUE;
		else
		{
			way_link(clo, ent);
			clo.waydist = 0;
			clo.waytagged = 0;
		}
	}
};

void() waypoint_autolink =
{	
	if (prelinked)
		return;
	local entity ent;
	ent = find(world, classname, "waypoint");

	while(ent)
	{
		find_autolinks(ent);
		ent = find(ent, classname, "waypoint");
	}
};