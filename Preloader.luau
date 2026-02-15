--[[
	MAKE: @BinTranDEV
--]]

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local player = Players.LocalPlayer

-- Remove default loading screen nếu muốn
pcall(function()
	ReplicatedFirst:RemoveDefaultLoadingScreen()
end)

local CLASS_PROPERTIES: {[string]: {string}} = {
	ImageLabel = {"Image"},
	ImageButton = {"Image"},
	Decal = {"Texture"},
	Texture = {"Texture"},
	MeshPart = {"MeshId","TextureID"},
	Sound = {"SoundId"},
	Animation = {"AnimationId"},
	ParticleEmitter = {"Texture"},
	Trail = {"Texture"},
	Beam = {"Texture"},
}

local function collect(container: Instance, list: {Instance})
	for _, obj in container:GetDescendants() do
		if CLASS_PROPERTIES[obj.ClassName] then
			table.insert(list, obj)
		end
	end
end

local start = os.clock()

local toLoad = {}

collect(game.ReplicatedStorage, toLoad)
collect(game.StarterGui, toLoad)
collect(game.SoundService, toLoad)

ContentProvider:PreloadAsync(toLoad)

print("Preload done in", math.floor((os.clock()-start)*1000), "ms")
