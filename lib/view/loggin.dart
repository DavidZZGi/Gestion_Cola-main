import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
               gradient:  LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)]),
    
            ), 
        child: const Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: SignUpForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm();
  
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _completeNameTextController = TextEditingController();
  final _phonetextController = TextEditingController();
  final _ciTextController = TextEditingController();

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateformprogress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Autentificación', style: Theme
              .of(context)
              .textTheme
              .headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _completeNameTextController,
              decoration: const InputDecoration(labelText: 'Nombre y Apellidos'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _phonetextController,
              decoration: const InputDecoration(labelText: 'Número de Teléfono'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              
              controller: _ciTextController,
              decoration: const InputDecoration(labelText: 'Carnet de Identidad'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.blue;
              }),
            ),
            onPressed: _formProgress==1 ? _showelcomescreen :null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Acceder',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                
              ),
              
              
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showelcomescreen() {
     Navigator.of(context).pushNamed('/cubacola');
  }
void _updateformprogress(){
  var progress = 0.0;
  final controllers = [
    _completeNameTextController,
    _phonetextController,
    _ciTextController
  ];

  for (final controller in controllers) {
    if (controller.value.text.isNotEmpty ) {
      progress += 1 / controllers.length;
    }
  }

  setState(() {
    _formProgress = progress;
  });
}
}




class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      
        duration: Duration(milliseconds: 1200), vsync: this);

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 2,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        minHeight: 12,
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.5),
      ),
    );
  }
}