from flask import render_template, session, url_for
from . import main

@main.route('/')
def index():
  return render_template(
    'index.html',
    coffeescripts=['player', 'game', 'main']
  )
