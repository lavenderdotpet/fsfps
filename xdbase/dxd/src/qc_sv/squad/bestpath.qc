.entity nodequeue;
.entity lastqueue;
.float noded;
.entity nodeparent;
.entity startnode;
.entity endnode;
.entity current;
.entity trackback;

.float route1;
.float route2;
.float route3;
.float route4;
.float route5;
.float route6;
.float route7;
.float route8;

entity orderlink1;
entity orderlink2;
entity orderlink3;
entity orderlink4;
entity orderlink5;
entity orderlink6;

void(entity next) add_to_queue = 
{
	if (!next.noded)
	{
		if (next != world)
		{
			next.noded = TRUE;
			next.nodeparent = self.current;
			self.lastqueue.nodequeue = next;
			self.lastqueue = next;
		}
	}
};

void(entity ent) link_order =
{
	local float l1, l2, l3, l4, l5, l6;
	local float templ;
	local entity tempe;

	l1 = vlen(ent.link1.origin - ent.origin);
	if (ent.link1 == world)
		l1 = 10000;
	orderlink1 = ent.link1;
	l2 = vlen(ent.link2.origin - ent.origin);
	if (ent.link2 == world)
		l2 = 10000;
	orderlink2 = ent.link2;
	l3 = vlen(ent.link3.origin - ent.origin);
	if (ent.link3 == world)
		l3 = 10000;
	orderlink3 = ent.link3;
	l4 = vlen(ent.link4.origin - ent.origin);
	if (ent.link4 == world)
		l4 = 10000;
	orderlink4 = ent.link4;
	l5 = vlen(ent.link5.origin - ent.origin);
	if (ent.link5 == world)
		l5 = 10000;
	orderlink5 = ent.link5;
	l6 = vlen(ent.link6.origin - ent.origin);
	if (ent.link6 == world)
		l6 = 10000;
	orderlink6 = ent.link6;

	while(1)
	{
		if (l1 > l2)
		{
			templ = l1;
			l1 = l2;
			l2 = templ;
			tempe = orderlink1;
			orderlink1 = orderlink2;
			orderlink2 = tempe;
		}
		if (l2 > l3)
		{
			templ = l2;
			l2 = l3;
			l3 = templ;
			tempe = orderlink2;
			orderlink2 = orderlink3;
			orderlink3 = tempe;
		}
		if (l3 > l4)
		{
			templ = l3;
			l3 = l4;
			l4 = templ;
			tempe = orderlink3;
			orderlink3 = orderlink4;
			orderlink4 = tempe;
		}
		if (l4 > l5)
		{
			templ = l4;
			l4 = l5;
			l5 = templ;
			tempe = orderlink4;
			orderlink4 = orderlink5;
			orderlink5 = tempe;
		}
		if (l5 > l6)
		{
			templ = l5;
			l5 = l6;
			l6 = templ;
			tempe = orderlink5;
			orderlink5 = orderlink6;
			orderlink6 = tempe;
		}
		if ((l1 <= l2) && (l2 <= l3) && (l3 <= l4) && (l4 <= l5) && (l5 <= l6))
			return;
	}
};

float(vector startpoint, vector endpoint) canwalk =
{
	local entity ent, oldself, cyc;
	local float flo;
	local string str;
	local vector oldorg, oldang;

	cyc = find(world, classname, "bot");

	while(cyc)
	{
		cyc.oldsolid = cyc.solid;
		cyc.solid = SOLID_NOT;
		cyc = find(cyc, classname, "bot");
	}

	self.solid = self.oldsolid;
	oldorg = self.origin;
	oldang = self.angles;

	self.angles = vectoangles(endpoint - startpoint);

	flo = vlen(endpoint - startpoint);

	if (walkmove(self.angles_y, flo))
		flo = TRUE;
	else
		flo = FALSE;

	cyc = find(world, classname, "bot");

	while(cyc)
	{
		cyc.solid = cyc.oldsolid;
		cyc = find(cyc, classname, "bot");
	}


	setorigin(self, oldorg);
	self.angles = oldang;

//	str = ftos(flo);
//	bprint(str);
//	bprint("\n");

	return flo;
};
	
entity() find_waypath =
{
	local entity ent, clos;
	local string str;
	local float fl;

	ent = find(world, classname, "waypoint");

	if (ent == world)
		return self.objective;

	while(ent)
	{	
		ent.nodequeue = world;
		ent.noded = FALSE;
		ent.nodeparent = world;
		ent = find(ent, classname, "waypoint");
	}

	self.startnode = nearestway(self);
	self.endnode = nearestway(self.objective);
	self.lastqueue = self.startnode;
	self.current = self.startnode;
	self.current.noded = TRUE;

// if ((canwalk(self.origin, self.objective.origin)) && (self.objective != world))
//		return self.objective;

	if (self.startnode == self.endnode)
		return self.objective;

	if ((self.startnode == world) || (self.endnode == world))
		return self.objective;

//	if (vlen(self.startnode.origin - self.origin) > 100)
//		return self.startnode;

	while(current)
	{	
		if (self.current != self.endnode)
		{
			link_order(self.current);

			add_to_queue(orderlink1);
			add_to_queue(orderlink2);
			add_to_queue(orderlink3);
			add_to_queue(orderlink4);
			add_to_queue(orderlink5);
			add_to_queue(orderlink6);

			self.current = self.current.nodequeue;
		}
		else
		{
//			bprint("path = ");
			while(fl != TRUE)
			{
//				str = ftos(self.current.waynum);
//				bprint(str);
//				bprint("   ");
				if (self.current.nodeparent == self.startnode)
					fl = TRUE;
				else
					self.current = self.current.nodeparent;
			}
			
//			bprint("  Going for ");
//			str = ftos(self.current.waynum);
//			bprint(str);
//			bprint("\n");

//			if ((self.current == self.endnode) && (visible(self.goalentity)))
//				return self.goalentity;

			return self.current;
		
		}
	}

	return world;
};