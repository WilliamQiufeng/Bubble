using Godot;

namespace Bubble;

public partial class GodotSingleton<T> : Node where T : GodotSingleton<T>
{
}