void(vector vec, vector vec2) lightning = 
{
	local entity ent;

	ent = spawn();

	te_lightning1(ent, vec, vec2);

	remove(ent);
};

void() Entity_Editor =
{
	local entity ent;
	local string str;

	if (self.edtime < time)
	{
		ent = find(world, classname, "waypoint");
		while(ent)
		{	
			if (ent.link1)
				lightning(ent.origin, ent.link1.origin);
			if (ent.link2)
				lightning(ent.origin, ent.link2.origin);
			if (ent.link3)
				lightning(ent.origin, ent.link3.origin);
			if (ent.link4)
				lightning(ent.origin, ent.link4.origin);
			if (ent.link5)
				lightning(ent.origin, ent.link5.origin);
			if (ent.link6)
				lightning(ent.origin, ent.link6.origin);
	
			ent = find(ent, classname, "waypoint");
		}
		
		self.edtime = time + 0.1;
	}
	
	if ((self.waypicked) && (!self.grouptog))
		setorigin(self.waypicked, self.cursor_trace_endpos);
	else
	{
		ent = findradius(self.cursor_trace_endpos, 50);
		
		while (ent)
		{
			if (ent.classname == "waypoint")
			{
				str = "waypoint ";
				str = strcat(str, ftos(ent.waynum));
				str = strcat(str, "\n");
				centerprint(self, str);
			}
			ent = ent.chain;
		}
	}
				
};

void() Entity_Editor_Toggle =
{
	local entity ent;
	local string str;

	enteditor = 1 - enteditor;

//	str = "cl_prydoncursor ";
//	str = strcat(str, ftos(enteditor));
//	stuffcmd(self, str);

	ent = find(world, classname, "waypoint");

	while(ent)
	{
		if (enteditor)
		{
			setmodel(ent, "progs/lod.spr");
			ent.scale = 0.5;
		}
		else
		{
			setmodel(ent, "progs/nothing.mdl");
			ent.scale = 0.5;
		}
		ent = find(ent, classname, "waypoint");
	}
};

void(entity sel) Editor_Pickedclick =
{
	return;
	if ((sel == world) || (sel == self.waypicked))
	{	
		setmodel(self.waypicked, "progs/lod.spr");
		self.waypicked = world;
		return;
	}
	
	if (self.grouptog)
	{
		if (way_linked(self.waypicked, sel))
			way_unlink(self.waypicked, sel);
		else
			way_link(self.waypicked, sel);

		setmodel(self.waypicked, "progs/lod.spr");
		self.waypicked = world;		
	}
};

void() Editor_Newway =
{
	local entity ent, wa;
	local float flo;

	return;
	flo = 0;

	wa = find(world, classname, "waypoint");

	while(wa)
	{
		if (wa.waynum > flo)
			flo = wa.waynum;
		
		wa = find(wa, classname, "waypoint");
	}

	ent = spawn();
	
	ent.movetype = MOVETYPE_NONE;
	setmodel(ent, "progs/lod.spr");
	ent.scale = 0.5;
	setsize (ent, '0 0 0', '0 0 0');
        setorigin (ent, self.cursor_trace_endpos);
        ent.classname = "waypoint";	
	ent.waynum = flo + 1;
};

void(entity sel) Waypoint_Remove =
{
	if (sel.link1)
		way_unlink(sel, sel.link1);
	if (sel.link2)
		way_unlink(sel, sel.link2);
	if (sel.link3)
		way_unlink(sel, sel.link3);
	if (sel.link4)
		way_unlink(sel, sel.link4);
	if (sel.link5)
		way_unlink(sel, sel.link5);
	if (sel.link6)
		way_unlink(sel, sel.link6);
	
	remove(sel);
};

void() Editor_Rightclick =
{
	local float d, j;
	local entity loc, sel;

	return;

	if (self.waypicked)
		return;

	j = 64;

	loc = findradius(self.cursor_trace_endpos, j);

	while(loc)
	{
		if (loc.classname == "waypoint")
		{
			d = vlen(loc.origin - self.cursor_trace_endpos);
	
			if (d < j)
			{
				j = d;
				sel = loc;
			}			
		}
		loc = loc.chain;
	}

	if (sel)
		Waypoint_Remove(sel);
};

void() Editor_Click =
{	
	local float d, j;
	local entity loc, sel;
	
	return;

	j = 64;

	loc = findradius(self.cursor_trace_endpos, j);

	while(loc)
	{
		if (loc.classname == "waypoint")
		{
			d = vlen(loc.origin - self.cursor_trace_endpos);
	
			if (d < j)
			{
				j = d;
				sel = loc;
			}			
		}
		loc = loc.chain;
	}

	if (self.waypicked)
		Editor_Pickedclick(sel);
	else if (sel)
	{
		self.waypicked = sel;
		setmodel(sel, "progs/lod2.spr");
	}
	else if (self.grouptog)
		Editor_Newway();
};

void(vector pos, float wnum, float l1, float l2, float l3, float l4, float l5, float l6) Editor_Loadwaypoint =
{
	local entity missile;

	missile = spawn ();
        missile.movetype = MOVETYPE_NONE;
	setmodel(missile, "progs/nothing.mdl");
        setsize (missile, '0 0 0', '0 0 0');
        setorigin (missile, pos);
        missile.classname = "waypoint";	

	missile.waynum = wnum;
	
	missile.lk1 = l1;
	missile.lk2 = l2;
	missile.lk3 = l3;
	missile.lk4 = l4;
	missile.lk5 = l5;
	missile.lk6 = l6;

	missile.think = waypoint_begin;
	missile.nextthink = time + random();
};

void() Editor_Deleteall =
{
	local entity ent;
	
	ent = find(world, classname, "waypoint");

	while(ent)
	{
		ent.think = SUB_Remove;
		ent.nextthink = time;
		ent = find(ent, classname, "waypoint");
	}
};

void() Editor_Save =
{
	local string file, str;
	local float flo, filenumber;
	local entity ent;


	file = world.model;
	flo = strlen(file);
	file = substring(file, 5, flo);
	flo = strlen(file);
	file = substring(file, 0, flo - 4);

	file = strcat("maps/", file);
	file = strcat(file, ".way");

	filenumber = fopen(file, FILE_WRITE);

	ent = find(world, classname, "waypoint");
	flo = 0;

	while(ent)
	{
		flo = flo + 1;
		ent = find(ent, classname, "waypoint");
	}

	str = ftos(flo);
	fputs(filenumber, str);
	fputs(filenumber, "\n");

	ent = find(world, classname, "waypoint");
	while(ent)
	{
		str = ftos(ent.origin_x);
		fputs(filenumber, str);
		fputs(filenumber, "\n");

		str = ftos(ent.origin_y);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		str = ftos(ent.origin_z);
		fputs(filenumber, str);
		fputs(filenumber, "\n");

		str = ftos(ent.waynum);
		fputs(filenumber, str);
		fputs(filenumber, "\n");

		str = ftos(ent.lk1);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		str = ftos(ent.lk2);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		str = ftos(ent.lk3);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		str = ftos(ent.lk4);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		str = ftos(ent.lk5);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		str = ftos(ent.lk6);
		fputs(filenumber, str);
		fputs(filenumber, "\n");
		
		ent = find(ent, classname, "waypoint");
	}

	fclose(filenumber);

	bprint("Waypoints saved to ");
	bprint(file);
	bprint("\n");
};

float() Editor_Load2 =
{
	local string file, str;
	local float i, flo, filenumber;
	local entity ent;
	local vector org;
	local float wnum, lin1, lin2, lin3, lin4, lin5, lin6;

	file = world.model;
	flo = strlen(file);
	file = substring(file, 5, flo);
	flo = strlen(file);
	file = substring(file, 0, flo - 4);

	file = strcat("maps/", file);
	file = strcat(file, ".way2");

	filenumber = fopen(file, FILE_READ);

	if (filenumber < 0)
		return FALSE;

	Editor_Deleteall();	
	
	str = fgets(filenumber);
	flo = stof(str);

	while(i < flo)
	{
		str = fgets(filenumber);
		org_x = stof(str);

		str = fgets(filenumber);
		org_y = stof(str);

		str = fgets(filenumber);
		org_z = stof(str);

		str = fgets(filenumber);
		wnum = stof(str);

		str = fgets(filenumber);
		lin1 = stof(str);

		str = fgets(filenumber);
		lin2 = stof(str);

		str = fgets(filenumber);
		lin3 = stof(str);

		str = fgets(filenumber);
		lin4 = stof(str);

		str = fgets(filenumber);
		lin5 = stof(str);

		str = fgets(filenumber);
		lin6 = stof(str);
	
		Editor_Loadwaypoint(org, wnum, lin1, lin2, lin3, lin4, lin5, lin6);

		i = i + 1;
	}
		
	fclose(filenumber);

	prelinked = TRUE;

	return TRUE;
};


void() Editor_Load =
{
	local string file, str;
	local float i, flo, filenumber;
	local entity ent;
	local vector org;
	local float wnum, lin1, lin2, lin3, lin4, lin5, lin6;

	if (Editor_Load2())
		return;

	file = world.model;
	flo = strlen(file);
	file = substring(file, 5, flo);
	flo = strlen(file);
	file = substring(file, 0, flo - 4);

	file = strcat("maps/", file);
	file = strcat(file, ".way");

	filenumber = fopen(file, FILE_READ);

	if (filenumber < 0)
		return;

	Editor_Deleteall();	

	
	while(!lin1)
	{
		str = fgets(filenumber);
		
		if (str == "END")
			lin1 = TRUE;
		else
		{
			org = stov(str);
				
			str = fgets(filenumber);
			str = fgets(filenumber);
		
			i++;
			
			Editor_Loadwaypoint(org, i,0,0,0,0,0,0);
		}
	}

	fclose(filenumber);
};