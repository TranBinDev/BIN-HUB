--!strict

-- Wait until game loaded
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- [[ Services ]]
local ContentProvider = game:GetService("ContentProvider")

-- [[ Variables ]]
local StartupTime = tick()

local AllAssets = {}
local ToLoadAssets = {}

-- Loadable assets
local ClassOnly = {
	Decal = { "Texture" },
	Texture = { "Texture" },
	ImageLabel = { "Image" },
	ImageButton = { "Image" },
	MeshPart = { "MeshId", "TextureID" },
	SpecialMesh = { "MeshId", "TextureId" },
	Sound = { "SoundId" },
	VideoFrame = { "Video" },
	Animation = { "AnimationId" },
	ParticleEmitter = { "Texture" },
	Trail = { "Texture" },
	Beam = { "Texture" },
	SurfaceAppearance = { "NormalMap", "MetalnessMap", "RoughnessMap" },
	MaterialVariant = { "NormalMap", "MetalnessMap", "RoughnessMap" },
	Sky = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" },
	Fire = { "Heat", "Size" },
	Smoke = { "Opacity" },
}

-- [[ Functions ]]
function GetAssets(container: Instance): ()
	for _, obj: Instance in container:GetDescendants() do
		if ClassOnly[obj.ClassName] ~= nil then
			for __, property: string in ClassOnly[obj.ClassName] do
				pcall(function()
					if obj[property] ~= "" and typeof(obj[property]) == "string" then
						AllAssets[obj[property]] = obj.Name
					end
				end)
			end
			table.insert(ToLoadAssets, obj)
		end
	end
end

function CallbackFunction(assetid: string, status: Enum.AssetFetchStatus): ()
	if status == Enum.AssetFetchStatus.Success or status == Enum.AssetFetchStatus.None or status == Enum.AssetFetchStatus.Loading then
		return nil
	end
	if AllAssets[assetid] then
		warn(`[Preloader] {AllAssets[assetid]} ({assetid}) loaded failed.`)
	else
		warn(`[Preloader] an unknown asset loaded failed.`)
	end
end

print(`[Preloader] loading all assets.`)

GetAssets(workspace)
GetAssets(game.ReplicatedStorage)
GetAssets(game.StarterGui)
GetAssets(game.SoundService)
GetAssets(game.Lighting)

ContentProvider:PreloadAsync(ToLoadAssets, CallbackFunction)

print(`[Preloader] loaded all assets in {tick() - StartupTime} ms.`)

-- Cleanup memory
ToLoadAssets = nil
AllAssets = nil
