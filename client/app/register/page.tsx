import React from "react";
import dynamic from "next/dynamic";

const RegisterForm = dynamic(() => import("components/forms/RegisterForm"), {
  ssr: false,
});

export default function RegisterPage() {
  return <RegisterForm />;
}
