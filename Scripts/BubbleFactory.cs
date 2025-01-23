using System;
using Godot;

namespace Bubble;

public static class BubbleFactory
{
    public static Bubble AddEffect(this Bubble bubble, EffectType effectType)
    {
        switch (effectType)
        {
            case EffectType.None:
                break;
            case EffectType.TheWorld:
                bubble.AddChild(new TheWorldBubbleEffectController());
                break;
            case EffectType.Teleport:
                break;
            case EffectType.Fast:
                bubble.AddChild(new FastBubbleEffectController());
                break;
            case EffectType.Dash:
                bubble.AddChild(new DashBubbleEffectController());
                break;
            case EffectType.Bullet:
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(effectType), effectType, null);
        }
        return bubble;
    }
    public static Bubble MakeBullet(this Bubble bubble, BulletType bulletType, Vector2 position, Vector2 target)
    {
        bubble.Position = position;
        switch (bulletType)
        {
            case BulletType.None:
                break;
            case BulletType.Tiny:
                bubble.AddChild(new BulletBubbleEffectController());
                bubble.LinearVelocity = (target - position).Normalized() * 100;
                break;
            case BulletType.Supplement:
                bubble.AddChild(new SupplementBubbleController(target));
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(bulletType), bulletType, null);
        }
        return bubble;
    }
}