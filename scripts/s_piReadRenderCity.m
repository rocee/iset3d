% s_piReadRenderCity
%
% Read a PBRT scene file, interpret it, render it (with depth map).  On a fast
% machine, this takes about 5 sec.
%
% Path requirements
%    ISET or ISETBIO
%    pbrt2ISET  - 
%    Consider RemoteDataToolbox for other uses.
%
%{
fname = fullfile(piRootPath,'data','bunny','bunny.pbrt');

% This has a lot of includes and dependencies.
% Also, in general, the includes need to be copied to the 'local' directory
% where the pbrt scene file and lens file are placed.
fname = fullfile(piRootPath,'data','teapot-metal','teapot-metal.pbrt');
%}
% TL/BW SCIEN

%% Set up ISET and Docker
ieInit;
if ~piDockerExists, piDockerConfig; end

%% Specify the pbrt scene file and its dependencies

% We organize the pbrt files with its includes (textures, brdfs, spds, geometry)
% in a single directory.
fname = fullfile(piRootPath,'data','MultiObject-City-1-Placement-2','City_1_placement_2_radiance.pbrt');
if ~exist(fname,'file'), error('File not found'); end

% Read the main scene pbrt file.  Return it as a recipe
thisR = piRead(fname);

%% Modify the recipe, thisR, to adjust the rendering

% Set camera position to (0,0,-3000)
thisR.set('from',[0 0 -3000]);

% Experimenting with different directions

% Pointing towards some kind of fire truck
thisR.set('to',[1.4e+03, 3.35e+04 -1500]);  

% Pointing towards a yellow school bus
% thisR.set('to',[-1.4e+03, -3.35e+04 -1500]);  

%% Set up Docker directory

% Write out the pbrt scene file, based on thisR.  By def, to the working directory.
[p,n,e] = fileparts(fname); 
thisR.set('outputFile',fullfile(piRootPath,'local','testCity',[n,e]));
piWrite(thisR);

%% Render with the Docker container

scene = piRender(thisR);

% Show it in ISET
vcAddObject(scene); sceneWindow; sceneSet(scene,'gamma',1);     

%%