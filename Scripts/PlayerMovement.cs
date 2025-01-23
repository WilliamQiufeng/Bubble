namespace Bubble;

using Godot;

public partial class PlayerMovement : CharacterBody2D
{
    [Export] public float Speed { get; set; } = 100;
    [Export] public AnimatedSprite2D AnimatedSprite { get; set; }
    [Export] public Node2D BulletContainer { get; set; }

    private Vector2 IdleDirection { get; set; } = Vector2.Down;

    private PackedScene _bubbleScene;

    private PlayerWeaponState PlayerWeaponState { get; set; }

    private Player Player { get; set; }

    private Vector2 DashVector { get; set; }

    public override void _Ready()
    {
        base._Ready();
        AnimatedSprite.Play("idle_towards");
        _bubbleScene = GD.Load<PackedScene>("res://bubble.tscn");
        Player = GetNode<Player>("PlayerController");
        PlayerWeaponState = GetNode<PlayerWeaponState>("PlayerWeaponState");
    }

    public bool GetAnimationDirection(Vector2 direction, out string animation, out bool flipH)
    {
        if (direction.X != 0)
        {
            animation = "left";
            flipH = direction.X > 0;
            return true;
        }

        if (direction.Y > 0)
        {
            animation = "towards";
            flipH = false;
            return true;
        }

        if (direction.Y < 0)
        {
            animation = "away";
            flipH = false;
            return true;
        }

        animation = "";
        flipH = false;

        return false;
    }

    public void GetInput()
    {
        var inputDirection = Input.GetVector("left", "right", "up", "down");
        Velocity = inputDirection * Speed;
        if (GetAnimationDirection(inputDirection, out var animation, out var flipH))
        {
            AnimatedSprite.Animation = $"walk_{animation}";
            AnimatedSprite.FlipH = flipH;
            IdleDirection = Velocity;
        }
        else
        {
            _ = GetAnimationDirection(IdleDirection, out var idleAnimation, out var _);
            AnimatedSprite.Animation = $"idle_{idleAnimation}";
        }

        if (Input.IsActionJustPressed("last_gun"))
        {
            PlayerWeaponState.SelectedBulletTypeIndex--;
        }

        if (Input.IsActionJustPressed("next_gun"))
        {
            PlayerWeaponState.SelectedBulletTypeIndex++;
        }

        if (Input.IsActionJustPressed("bubble_slot_1"))
        {
            PlayerWeaponState.SelectedEffectTypeIndex = 1;
        }

        if (Input.IsActionJustPressed("bubble_slot_2"))
        {
            PlayerWeaponState.SelectedEffectTypeIndex = 2;
        }

        if (Input.IsActionJustPressed("bubble_slot_3"))
        {
            PlayerWeaponState.SelectedEffectTypeIndex = 3;
        }

        if (Input.IsActionJustPressed("dash"))
        {
            DashVector = IdleDirection.Normalized() * Speed * 2;
        }
    }

    public override void _Input(InputEvent @event)
    {
        base._Input(@event);
        // Use IsActionPressed to only accept single taps as input instead of mouse drags.
        if (@event.IsActionPressed("click", true))
        {
            var target = GetGlobalMousePosition();
            var newBullet = _bubbleScene.Instantiate<Bubble>();
            BulletContainer.AddChild(newBullet);
            newBullet
                .AddEffect(PlayerWeaponState.CurrentEffectType)
                .MakeBullet(PlayerWeaponState.CurrentBulletType, Position, target);
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        GetInput();
        // using MoveAndCollide
        var collision = MoveAndCollide((Velocity + DashVector) * (float)delta);
        if (collision != null)
        {
            Velocity = Velocity.Slide(collision.GetNormal());
        }

        DashVector = DashVector.Lerp(Vector2.Zero, (float)delta * 7);
    }

    public void Fast(float multiplier) => Speed *= multiplier;
}