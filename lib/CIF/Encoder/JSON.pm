package CIF::Encoder::JSON;

use strict;
use warnings;
use CIF::MsgHelpers;
use CIF::Models::Submission;
require JSON;


sub new {
  my $class = shift;
}


sub encode_submission {
  my $self = shift;
  my $submission = shift;

  my $event = $submission->event();
  my $event_data = {};
  map { $event_data->{$_} = $event->{$_} } keys %{$event};

  my $submission_data = {
    apikey => $submission->apikey,
    guid => $submission->guid,
    event => $event_data
  };

  return JSON::encode_json($submission_data);

  #my $iodefs = CIF::MsgHelpers::generate_iodef($submission->event());
  #my $msg = CIF::MsgHelpers::build_submission_msg($submission->apikey, $submission->guid, $iodefs);
  #return($msg->encode());
}

sub decode_submission {
  my $self = shift;
  my $json = shift;
  my $data = JSON::decode_json($json);

  my $event = CIF::Models::Event->new($data->{event});
  return CIF::Models::Submission->new($data->{apikey}, $data->{guid}, $event);
}


1;
