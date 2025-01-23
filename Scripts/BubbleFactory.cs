using System;
using System.Collections.Generic;
using Godot;

namespace Bubble;

public class BubbleFactory
{
    public float ManaCost { get; private set; }
    private List<EffectType> EffectTypes { get; } = new();
    private BulletType BulletType { get; set; }
    private Vector2 Position { get; set; }
    private Vector2 Target { get; set; }

    public BubbleFactory Apply(Bubble bubble)
    {
        foreach (var effectType in EffectTypes)
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
        }
        bubble.Position = Position;
        switch (BulletType)
        {
            case BulletType.None:
                break;
            case BulletType.Tiny:
                bubble.AddChild(new BulletBubbleEffectController());
                bubble.LinearVelocity = (Target - Position).Normalized() * 100;
                break;
            case BulletType.Supplement:
                bubble.AddChild(new SupplementBubbleController(Target));
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(BulletType), BulletType, null);
        }
        return this;
    }

    public BubbleFactory AddEffect(EffectType effectType)
    {
        EffectTypes.Add(effectType);
        ManaCost += effectType switch
        {
            EffectType.TheWorld => 10,
            EffectType.Teleport => 10,
            EffectType.Fast => 3,
            EffectType.Dash => 5,
            _ => throw new ArgumentOutOfRangeException(nameof(effectType), effectType, null)
        };
        return this;
    }

    public BubbleFactory MakeBullet(BulletType bulletType, Vector2 position, Vector2 target)
    {
        BulletType = bulletType;
        Position = position;
        Target = target;
        ManaCost *= bulletType switch
        {
            BulletType.None => 0,
            BulletType.Tiny => 0.1f,
            BulletType.Supplement => 1,
            _ => throw new ArgumentOutOfRangeException(nameof(bulletType), bulletType, null)
        };
        return this;
    }
}