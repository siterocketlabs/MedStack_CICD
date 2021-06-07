This Demo App worked !!<br>

<?php

ini_set('display_errors', 1);

echo "Getting source...";

echo "Medstack's Secret is: " . getenv('THESECRET');
