import React from "react";
import dynamic from "next/dynamic";

const RegisterForm = dynamic(() => import("components/form/RegisterForm"), {
  ssr: false,
});

export default function RegisterPage() {
  return <RegisterForm />;
}
