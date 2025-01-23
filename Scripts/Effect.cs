using Godot;

namespace Bubble;

public abstract record Effect(EffectType Type);
public record TheWorldEffect() : Effect(EffectType.TheWorld);
public record TeleportEffect(Timer Cooldown, Vector2 Position) : Effect(EffectType.Teleport);
public record FastEffect() : Effect(EffectType.Fast);

public enum EffectType
{
    TheWorld,
    Teleport,
    Fast
}