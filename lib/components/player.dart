import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/anchor.dart';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/semantics.dart';

const num SIZE = 48.0;

class Player extends SpriteComponent {
  PlayerBody body;
  bool dead = false;

  Player(box) : super.fromSprite(SIZE, SIZE, new Sprite("virus/virus.png")) {
    anchor = Anchor.center;
    x = 0;
    y = -160;
    body = PlayerBody(box, this);
  }

  jump() {
    print("jump!"); //DEBUG
    body.body.applyLinearImpulse(
        new Vector2(0, -5000), new Vector2(0, 0), true); //TODO parameter tuning
  }

  die() {
    if (!dead) {
      dead = true;
      print("!!!DIED!!!"); //DEBUG
    }
  }
}

class PlayerBody extends BodyComponent {
  SpriteComponent sprite;

  PlayerBody(box, this.sprite) : super(box) {
    _createBody();
  }

  void _createBody() {
    final shape = new CircleShape();
    shape.radius = 0.5 * SIZE;

    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.restitution = 0.0;
    fixtureDef.density = 0.05;
    fixtureDef.friction = 0.2;
    final bodyDef = new BodyDef();
    bodyDef.position = new Vector2(sprite.x, sprite.y);
    bodyDef.linearVelocity = new Vector2(0.0, 0.0);
    bodyDef.type = BodyType.DYNAMIC;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    //DEBUG
    CircleShape shape = body.getFixtureList().getShape();
    Paint paint = Paint()..color = const Color(0x99FF0000);
    canvas.drawCircle(
        Offset(body.position.x, body.position.y), shape.radius, paint);
  }

  @override
  void update(num t) {
    // update sprite position
    sprite.x = body.position.x;
    sprite.y = body.position.y;
  }
}
