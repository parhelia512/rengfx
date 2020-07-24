module re.gfx.shapes.rect;

import re.ecs;
import re.gfx;
import re.math;
static import raylib;

/// a color-filled rectangle
class ColorRect : Component, Renderable2D {
    /// rectangle dimensions
    public Vector2 size;
    /// fill color
    public Color color;

    this(Vector2 size, raylib.Color color, bool fill = true) {
        this.size = size;
        this.color = color;
    }

    @property Rectangle bounds() {
        return Rectangle(entity.position2.x, entity.position2.y, size.x, size.y);
    }

    void render() {
        raylib.DrawRectanglePro(Rectangle(entity.position2.x,
                entity.position2.y, size.x, size.y), size / 2,
                entity.transform.rotation * RAD2DEG, color);
    }

    void debug_render() {
    }
}