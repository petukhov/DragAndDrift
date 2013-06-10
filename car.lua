local math = require "math"

car = {}
car.__index = car

function car.new(name, topSpeed)
	local newcar = {
		name = name or "bibika",
		topSpeed = topSpeed or 100
	}
	newcar.carImage = display.newImageRect("cartop.png", 97, 49)
	newcar.carImage:setReferencePoint(display.CenterReferencePoint)
	newcar.carImage.x = 180 
	newcar.carImage.y = 160 

	newcar.carSpX=0 
	newcar.carSpY=0 
	newcar.carAccX=0 
	newcar.carAccY=0
	newcar.prevX=0 
	newcar.prevY=0
	newcar.currentTouchX=0 
	newcar.currentTouchY=0
	newcar.carSpeed=0 
	newcar.steerAngle=0 
	newcar.wheelBase=97
	newcar.frontWheelX=newcar.carImage.x+newcar.wheelBase/2 
	newcar.frontWheelY=newcar.carImage.y 
	newcar.backWheelX=newcar.carImage.x-newcar.wheelBase/2 
	newcar.backWheelY=newcar.carImage.y 
	newcar.carSpeed=0 
	newcar.carAcc=0

	return setmetatable(newcar, car)
end

function car:printName()	
	print(self.name)
end

function car:nextFrame()
	self.carSpeed = self.carSpeed + self.carAcc/4
	self.carSpeed = self.carSpeed*0.9
end

function car:move(currentTouchX, currentTouchY)
	local distX = currentTouchX - self.carImage.x
	local distY = currentTouchY - self.carImage.y
	local dist = math.sqrt(distX^2+distY^2)
	local carRotation = self.carImage.rotation*math.pi/180

	self.steerAngle = math.atan2(distY, distX)
	self.carAcc = dist/60

	self.frontWheelX = self.carImage.x + (self.wheelBase/2)*math.cos(carRotation)
	self.frontWheelY = self.carImage.y + (self.wheelBase/2)*math.sin(carRotation)
	self.backWheelX = self.carImage.x - (self.wheelBase/2)*math.cos(carRotation)
	self.backWheelY = self.carImage.y - (self.wheelBase/2)*math.sin(carRotation)

	self.backWheelX = self.backWheelX + self.carSpeed * math.cos(carRotation)
	self.backWheelY = self.backWheelY + self.carSpeed * math.sin(carRotation)
	self.frontWheelX = self.frontWheelX + self.carSpeed * math.cos(self.steerAngle)
	self.frontWheelY = self.frontWheelY + self.carSpeed * math.sin(self.steerAngle)
	--print(math.cos(carRotation))

	self.carImage.x = (self.backWheelX + self.frontWheelX)/2
	self.carImage.y = (self.backWheelY + self.frontWheelY)/2

	self.carImage.rotation = 180*math.atan2(self.frontWheelY - self.backWheelY, self.frontWheelX - self.backWheelX)/math.pi
end

function car:accZero()
	self.carAcc = 0
end

return car