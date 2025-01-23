using Godot;

namespace Bubble;

public partial class AnimationProgressBar : AnimatedSprite2D
{
    [Export] public string AnimationName = "default";
    
    public void SetProgress(float _, float progress)
    {
        var frame = (int) (progress * SpriteFrames.GetFrameCount(AnimationName));
        Frame = frame;
    }
}