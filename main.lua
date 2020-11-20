src1 = love.audio.newSource("Tetris.mp3", "stream")
src1:setVolume(0.1)
src1:setLooping(true)
src1:play()
function love.load()
	world = love.physics.newWorld(0, 150, true)
	love.graphics.setBackgroundColor(1,1,1)
  	ground = {}
  	ground.body = love.physics.newBody(world, 400,1150/2)
  	ground.shape = love.physics.newRectangleShape(800, 0)
  	ground.fixture = love.physics.newFixture(ground.body, ground.shape)
  	wall = {}
  	wall.body = love.physics.newBody(world, 0, 1150/2)
  	wall.shape = love.physics.newRectangleShape(0,1200)
  	wall.fixture = love.physics.newFixture(wall.body, wall.shape)
  	wall2 = {}
  	wall2.body = love.physics.newBody(world, 795, 1150/2)
  	wall2.shape = love.physics.newRectangleShape(0,1200)
  	wall2.fixture = love.physics.newFixture(wall2.body, wall2.shape)
  	ceiling = {}
  	ceiling.body = love.physics.newBody(world, 400, 0)
  	ceiling.shape = love.physics.newRectangleShape(800, 0)
  	ceiling.fixture = love.physics.newFixture(ceiling.body, ceiling.shape)
  	pad = {}
  	pad.body = love.physics.newBody(world, 400, 1150/2,"static")
  	pad.shape = love.physics.newRectangleShape(60, 30)
  	pad.fixture = love.physics.newFixture(pad.body, pad.shape)
	pad.fixture:setFriction(5)
	ball = {}
	ball.body = love.physics.newBody(world, 175,120, "dynamic")
	ball.shape = love.physics.newCircleShape(25)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape)
	ball.fixture:setRestitution(1.07)
	math.randomseed(os.time())
	x=math.random(-100,100)
	ball.body:setLinearVelocity(x,math.sqrt(10000-x^2))
	print(x)
	t=os.clock()
	l=os.clock()
	z=0
	clones={}
	obstacles={}
end
start=0
name=""
l=0
function love.keypressed(k)
	if start==0 then
		if string.len(k)==1 then
			name=name..k
		end
		if k=="backspace" then
			name=name:sub(1, #name - 1)
		end
		if k=="return" then	
			t=os.clock()
			l=os.clock()
			b=os.clock()
			start=1
		end
	end
	if start==2 then
		if k=="r" then
			start=0
			ball.body:setPosition(175,120)
			pad.body:setPosition(400,1150/2)
			for i,v in pairs(obstacles) do
				v.body:destroy()
			end
			for i,v in pairs(clones) do
				v.body:destroy()
			end
			obstacles={}
			clones={}
			name=""
		end
	end
end
k=0
a=""
function love.update(dt)
	world:update(dt)
	if start==1 then
		if ground.body:getY()-ball.body:getY()<30 then
			if math.abs(ball.body:getX()-pad.body:getX())>25 then
				time=tostring(os.clock()-b)
				k=io.open("scores.txt","a+")
				io.input(k)
				a=k:read("*all")
				io.output(k)
				if a=="" then
					io.write("name time".."\n")
				end
				io.write(name.." "..time.."\n")
				k:seek("set")
				a=k:read("*all")
				k:close()
				start=2
			end
		end
	end
	if start==1 then
		if math.abs(pad.body:getX()-795)<30 then
			print("")
		else
  			if love.keyboard.isDown("right") then
    				pad.body:setX(pad.body:getX()+5)
			end
		end
		if pad.body:getX()-0<30 then
			print("")
		else
  			if love.keyboard.isDown("left") then
    				pad.body:setX(pad.body:getX()-5)
			end
		end
		if math.ceil(os.clock()-t)==15 then
			if table.getn(obstacles)<10 then
				block={}
				block.body = love.physics.newBody(world, math.random(20,780),math.random(20,1000/2))
				block.body:setAngle(math.random(0,math.pi))
				block.shape = love.physics.newRectangleShape(60, 30)
				block.fixture = love.physics.newFixture(block.body, block.shape)
				table.insert(obstacles,block)
				t=os.clock()
			end
		end
		if z==0 then
			if math.ceil(os.clock()-l)==60 then
				clone1={}
				clone1.body = love.physics.newBody(world, 150,120, "dynamic")
				clone1.shape = love.physics.newCircleShape(25)
				clone1.fixture = love.physics.newFixture(clone1.body, clone1.shape)
				clone1.fixture:setRestitution(1.08)
				clone1.body:setLinearVelocity(math.random(0,100),math.random(0,100))
				clone2={}
				clone2.body = love.physics.newBody(world, 150,120, "dynamic")
				clone2.shape = love.physics.newCircleShape(25)
				clone2.fixture = love.physics.newFixture(clone2.body, clone2.shape)
				clone2.fixture:setRestitution(1.08)
				clone2.body:setLinearVelocity(math.random(0,100),math.random(0,100))
				table.insert(clones,clone1)
				table.insert(clones,clone2)
				z=1	
			end	
		end
	elseif start==0 then
		ball.body:setPosition(175,120)
		ball.body:setLinearVelocity(x,math.sqrt(10000-x^2))
	end
end

function love.draw()
	if start==1 then
		love.graphics.setColor(0.78,0,0)
		if table.getn(clones)>0 then
			for i,v in pairs(clones) do
				love.graphics.circle("fill", v.body:getX(),v.body:getY(), v.shape:getRadius())
			end
		end
		love.graphics.setColor(0,0,0)
		if table.getn(obstacles)>0 then
			for i,v in pairs(obstacles) do
				love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
			end
		end
  		love.graphics.polygon("fill", pad.body:getWorldPoints(pad.shape:getPoints()))
		love.graphics.setColor(1,0,0)
  		love.graphics.circle("fill", ball.body:getX(),ball.body:getY(), ball.shape:getRadius())
	elseif start==0  then
		love.graphics.setColor(0,0,0)
		love.graphics.print("enter your username",10,30)
		love.graphics.print("your name:"..name,10,45)
	else
		love.graphics.clear()
		love.graphics.print(a,100,100)
		love.graphics.print("press r to replay",100,50)
	end	
end