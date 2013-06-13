-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local math = require "math"
local carClass = require "car"

local physics = require "physics"
physics.start();
physics.setGravity(0,0)
local bkg = display.newImage("racingtrack.png")
local physicsData = (require "physicsboundary").physicsData(1.0)

local thing = display.newRect(508,379, 10, 10)
physics.addBody(thing, "static", physicsData:get("racingtrack_inner"))

local thing2 = display.newRect(508, 379, 10, 10)
physics.addBody(thing2, "static", physicsData:get("racingtrack_outer"))

local thing3 = display.newRect(508, 379, 10, 10)
physics.addBody(thing3, "static", physicsData:get("racingtrack_outer1"))

--adding sounds
local sounds = {bump = audio.loadSound("bounce.wav")}

--adding the car object to the stage
local newCar = carClass.new("racer")

-- useful declarations
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

physics.addBody(newCar.carImage, "dynamic")

local pressed = false

--for smoke effect
local emitter = require("emitter")
local mainGroup = display.newGroup()
local emit1
local i

function onTouch(event)
	local distX = event.x - newCar.carImage.x
	local distY = event.y - newCar.carImage.y
	local dist = math.sqrt(distX^2+distY^2)
	currentTouchX = event.x
	currentTouchY = event.y
	if event.phase == "began" then
		pressed = true
	elseif event.phase == "moved" then
		
	elseif event.phase == "ended" or event.phase == "cancelled" then
		pressed = false
	end
	return true
end

function gameLoop(event)
	newCar:nextFrame()
	if pressed then
		newCar:move(currentTouchX, currentTouchY)
	else 
		newCar:accZero()
	end
end

local function init()

emit1 = emitter.createEmitter(300,  50,  1500, 0.1, 0)
emitter.setColor(emit1,200,200,200)

end


local function burst()

    for i = 1,10 do
		emitter.emit(emit1, mainGroup, newCar.carImage.x, newCar.carImage.y)   
		
	end	
	
	
end




local function onCollision( event )
       audio.play(sounds.bump)
end

Runtime:addEventListener("touch", onTouch)
Runtime:addEventListener("enterFrame", gameLoop) 
Runtime:addEventListener( "collision", onCollision )
Runtime:addEventListener("collision", burst)

init()


-----------------------------------------------------------------------------------------

return scene