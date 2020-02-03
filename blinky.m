function blinky(n, resolution, frames, frameRate, blinkRate, closedFraction)
% Produces and exports a gif with square tiles of cartoony eyes that blink
% regularly. 

% Args:
% n - number of eyes per side (square)
% resolution - number of pixels per side in animation (square)
% frames - total frames to be saved
% frameRate - frames per second
% blinkRate - avg. blinks per second
% closedFraction - avg. fraction of time each eye will be closed. Between 0 and 1

close all; clc
eyeball_size = resolution/n;

I = rgb2gray(imread("eyes.png"))/255;
f = zeros(eyeball_size, eyeball_size, 3);
wide = imresize(I(50:280, 460:710), [eyeball_size, eyeball_size], "method", "nearest");
middle = imresize(I(70:320, 30:300), [eyeball_size, eyeball_size], "method", "nearest");
closed = imresize(I(340:560, 500:720), [eyeball_size, eyeball_size], "method", "nearest");
skip_odds = .5*blinkRate/frameRate; 
A = ones(resolution);
[X, Y] = meshgrid(1:eyeball_size:resolution, 1:eyeball_size:resolution);
pos = [X(:), Y(:)];
n = size(pos, 1);

isOpen = true(1, n);
blinking = false(1, n);

for i = 1:n % for each eyeball
    A(pos(i, 1):pos(i, 1) + eyeball_size - 1, pos(i, 2):pos(i, 2) + eyeball_size - 1) = wide;
end
exportAsGif(A, 1, frameRate)
for frame = 2:frames
    for i = 1:n % for each eyeball
        if blinking(i)
            isOpen(i) = not(isOpen(i));
            blinking(i) = false;
            if isOpen(i)
                A(pos(i, 1):pos(i, 1) + eyeball_size - 1, pos(i, 2):pos(i, 2) + eyeball_size - 1) = wide;
            else
                A(pos(i, 1):pos(i, 1) + eyeball_size - 1, pos(i, 2):pos(i, 2) + eyeball_size - 1) = closed;
            end
        elseif rand > skip_odds
            % do nothing
        elseif isOpen(i) && rand > (1 - closedFraction)
            blinking(i) = true;
            A(pos(i, 1):pos(i, 1) + eyeball_size - 1, pos(i, 2):pos(i, 2) + eyeball_size - 1) = middle;
        elseif not(isOpen(i)) && rand > closedFraction
            blinking(i) = true;
            A(pos(i, 1):pos(i, 1) + eyeball_size - 1, pos(i, 2):pos(i, 2) + eyeball_size - 1) = middle;
        end
        
    end
    exportAsGif(A, frame, frameRate)
end

end

function exportAsGif(A, n, frameRate)
% h = gcf;
% axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';

% Capture the plot as an image
% frame = getframe(h);
im = imresize(A, [500, 500], "method", "nearest");
[imind,cm] = gray2ind(im,2);
% Write to the GIF File
if n == 1
    imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/frameRate);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/frameRate);
end
end
