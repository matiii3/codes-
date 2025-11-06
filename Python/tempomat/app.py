import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import numpy as np
import math

app = dash.Dash(__name__)

tp = 0.1
tsin = 200
ti = 2.5
kp = 0.2
v_zad = [0]
v = [0]
e = [v_zad[-1]]
t = [0.0]
i = [0.0]
v_2 = 10.0
g = 9.81
alfa = 0
p = 100
v_max = 180
m = 1300
b = 30
F = p * 2 / v_max * 3.6 * 0.74 * 1000
a_max = F / m
f = [F]
fmax = F
fmin = 0
umin = -a_max * tp
umax = a_max * tp
u = [umax]
throttle = [u[-1] / (a_max * tp) * 100]

app.layout = html.Div([
    html.Label('ti'),
    dcc.Slider(
        id='ti-slider',
        min=0.1,
        max=5.0,
        step=0.1,
        value=ti,
        marks={i: str(round(i, 1)) for i in np.arange(0.2, 5.1, 0.2)}
    ),
    html.Label('kp'),
    dcc.Slider(
        id='kp-slider',
        min=0.1,
        max=1.0,
        step=0.1,
        value=kp,
        marks={i: str(round(float(i), 1)) for i in np.arange(0.1, 1.1, 0.1)}
    ),
    html.Label('Prędkość zadana'),
    dcc.Slider(
        id='v-zad-slider',
        min=1.0,
        max=v_max / 3.6,
        step=1.0,
        value=27.77
    ),
    html.Label('Prędkość zadana po czasie 100 sekund'),
    dcc.Slider(
        id='v-2-slider',
        min=0.0,
        max=v_max / 3.6,
        step=1.0,
        value=v_2
    ),
    html.Label('Kąt wzniesienia drogi'),
    dcc.Slider(
        id='alfa-slider',
        min=0,
        max=10,
        step=1,
        value=alfa
    ),
    dcc.Graph(id='velocity-graph'),
    dcc.Graph(id='control-signal-graph')
])


@app.callback(
    [Output('velocity-graph', 'figure'),
     Output('control-signal-graph', 'figure')],
    [Input('ti-slider', 'value'),
     Input('kp-slider', 'value'),
     Input('v-zad-slider', 'value'),
     Input('v-2-slider', 'value'),
     Input('alfa-slider', 'value')]
)
def update(ti_val, kp_val, v_zad_val, v_2_val, alfa_val):
    global ti, kp, v_zad, v, u, e, t, i, v_2, f, alfa, tsin, throttle
    ti = ti_val
    kp = kp_val
    v_zad = [v_zad_val]
    v_2 = v_2_val
    alfa = math.radians(alfa_val)

    v = [0.0]
    u = [umax]
    e = [v_zad[-1] - v[-1]]
    t = [0.0]
    throttle = [u[-1] / (a_max * tp) * 100]
    f = [F]

    for x in range(1, int(tsin / tp) + 1):
        t.append(t[-1] + tp)
        if t[-1] >= 100:
            v_zad.append(v_2)
        else:
            v_zad.append(v_zad[-1])
        e.append(v_zad[-1] - v[-1])
        if (kp * ((e[-1] - e[-2]) + ((tp / ti) * e[-1])) + u[-1]) / tp > a_max:
            u.append(umax)
        elif (kp * ((e[-1] - e[-2]) + ((tp / ti) * e[-1])) + u[-1]) / tp < -a_max:
            u.append(umin)
        else:
            u.append(kp * ((e[-1] - e[-2]) + ((tp / ti) * e[-1])) + u[-1])
        throttle.append(u[-1] / (a_max * tp) * 100)
        v.append(min(max(tp / m * (f[-1] - b * v[-1] - m * g * math.sin(alfa)) + v[-1], 0), v_max / 3.6))
        f.append((fmax - fmin) / (umax - umin) * (u[-1] - umin) + fmin)

    velocity_fig = {
        'data': [{'x': t, 'y': v, 'type': 'line', 'name': 'Prędkość'}],
        'layout': {'xaxis': {'title': 't [s]'}, 'yaxis': {'title': 'v [m/s]'}, 'title': 'Wykres prędkości'}
    }

    control_signal_fig = {
        'data': [{'x': t, 'y': throttle, 'type': 'line', 'name': 'Sygnał sterujący', 'line': {'color': 'orange'}}],
        'layout': {'xaxis': {'title': 't [s]'}, 'yaxis': {'title': 'u [%]'}, 'title': 'Sygnał sterujący w czasie'}
    }

    return velocity_fig, control_signal_fig


if __name__ == '__main__':
    app.run_server(debug=True)
